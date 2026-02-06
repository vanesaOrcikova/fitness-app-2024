//
//  MyPlanModelsStore.swift
//  FitnessApp
//
//  Created by Vanesa Orcikova on 01/02/2026.
//

import Foundation
import SwiftUI

enum PlanSection: String, CaseIterable, Codable {
    case workout = "Daily plan"
    case meal = "Meal Plan"
}

enum PlanKind: String, CaseIterable, Codable {
    case normal = "Normal"
    case shopping = "Shopping"
}

enum PlanPriority: String, CaseIterable, Codable {
    case low = "Low"
    case medium = "Medium"
    case high = "High"
}

struct GroceryItem: Identifiable, Codable, Equatable {
    var id: UUID = UUID()
    var name: String
    var isDone: Bool
}

struct PlanItem: Identifiable, Codable, Equatable {
    var id: UUID = UUID()

    var title: String
    var note: String
    var section: PlanSection

    // Daily: kind always .normal, priority used
    // Blog(Meal): kind can be .normal/.shopping, priority ignored in UI
    var kind: PlanKind
    var priority: PlanPriority

    var startTime: Date?
    var endTime: Date?

    var isDone: Bool
    var createdAt: Date

    var groceries: [GroceryItem]

    enum CodingKeys: String, CodingKey {
        case id, title, note, section, kind, priority, startTime, endTime, isDone, createdAt, groceries
    }

    init(
        id: UUID = UUID(),
        title: String,
        note: String,
        section: PlanSection,
        kind: PlanKind,
        priority: PlanPriority,
        startTime: Date?,
        endTime: Date?,
        isDone: Bool,
        createdAt: Date,
        groceries: [GroceryItem]
    ) {
        self.id = id
        self.title = title
        self.note = note
        self.section = section

        if section == .workout {
            self.kind = .normal
            self.priority = priority
            self.groceries = []
        } else {
            self.kind = kind
            self.priority = .medium // ignored in Blog UI
            self.groceries = (kind == .shopping) ? groceries : []
        }

        self.startTime = startTime
        self.endTime = endTime
        self.isDone = isDone
        self.createdAt = createdAt
    }

    // migration-safe decode
    init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: CodingKeys.self)

        id = try c.decodeIfPresent(UUID.self, forKey: .id) ?? UUID()
        title = try c.decodeIfPresent(String.self, forKey: .title) ?? ""
        note = try c.decodeIfPresent(String.self, forKey: .note) ?? ""
        section = try c.decodeIfPresent(PlanSection.self, forKey: .section) ?? .workout
        kind = try c.decodeIfPresent(PlanKind.self, forKey: .kind) ?? .normal
        priority = try c.decodeIfPresent(PlanPriority.self, forKey: .priority) ?? .medium
        startTime = try c.decodeIfPresent(Date.self, forKey: .startTime)
        endTime = try c.decodeIfPresent(Date.self, forKey: .endTime)
        isDone = try c.decodeIfPresent(Bool.self, forKey: .isDone) ?? false
        createdAt = try c.decodeIfPresent(Date.self, forKey: .createdAt) ?? Date()
        groceries = try c.decodeIfPresent([GroceryItem].self, forKey: .groceries) ?? []

        // enforce rules
        if section == .workout {
            kind = .normal
            groceries = []
        } else if kind != .shopping {
            groceries = []
        }
    }
}

final class MyPlanStore: ObservableObject {

    @Published var items: [PlanItem] = []

    @Published var currentStreak: Int = 0
    @Published var lastCompletionDay: Date? = nil

    private let storageKey = "myPlanItemsStorage_v5"
    private let streakKey = "myPlan_currentStreak_v1"
    private let lastDayKey = "myPlan_lastCompletionDay_v1"

    init() {
        load()
        loadStreak()
    }

    var todayDoneCount: Int { items.filter { $0.isDone }.count }
    var todayTotalCount: Int { items.count }

    var isPerfectDay: Bool {
        todayTotalCount > 0 && todayDoneCount == todayTotalCount
    }

    func add(item: PlanItem) {
        items.insert(item, at: 0)
        save()
    }

    func update(_ item: PlanItem, updated: PlanItem) {
        if let idx = items.firstIndex(where: { $0.id == item.id }) {
            items[idx] = updated
            save()
        }
    }

    func delete(_ item: PlanItem) {
        items.removeAll { $0.id == item.id }
        save()
    }

    @discardableResult
    func toggleDone(_ item: PlanItem) -> Bool {
        if let idx = items.firstIndex(where: { $0.id == item.id }) {
            items[idx].isDone.toggle()
            let nowDone = items[idx].isDone
            if nowDone { registerTodayCompletionIfNeeded() }
            save()
            return nowDone
        }
        return false
    }

    func toggleGrocery(to item: PlanItem, grocery: GroceryItem) {
        if let idx = items.firstIndex(where: { $0.id == item.id }) {
            if let gIdx = items[idx].groceries.firstIndex(where: { $0.id == grocery.id }) {
                items[idx].groceries[gIdx].isDone.toggle()
                save()
            }
        }
    }

    // MARK: streak

    private func registerTodayCompletionIfNeeded() {
        let cal = Calendar.current
        let today = cal.startOfDay(for: Date())

        guard let last = lastCompletionDay else {
            currentStreak = 1
            lastCompletionDay = today
            saveStreak()
            return
        }

        if cal.isDate(last, inSameDayAs: today) { return }

        if let yesterday = cal.date(byAdding: .day, value: -1, to: today),
           cal.isDate(last, inSameDayAs: yesterday) {
            currentStreak += 1
        } else {
            currentStreak = 1
        }

        lastCompletionDay = today
        saveStreak()
    }

    private func saveStreak() {
        UserDefaults.standard.set(currentStreak, forKey: streakKey)
        if let last = lastCompletionDay {
            UserDefaults.standard.set(last.timeIntervalSince1970, forKey: lastDayKey)
        } else {
            UserDefaults.standard.removeObject(forKey: lastDayKey)
        }
    }

    private func loadStreak() {
        currentStreak = UserDefaults.standard.integer(forKey: streakKey)
        if let last = UserDefaults.standard.object(forKey: lastDayKey) as? Double {
            lastCompletionDay = Date(timeIntervalSince1970: last)
        } else {
            lastCompletionDay = nil
        }
    }

    // MARK: persistence

    private func save() {
        do {
            let data = try JSONEncoder().encode(items)
            UserDefaults.standard.set(data, forKey: storageKey)
        } catch {
            print("Save error:", error)
        }
    }

    private func load() {
        guard let data = UserDefaults.standard.data(forKey: storageKey) else {
            items = []
            return
        }
        do {
            items = try JSONDecoder().decode([PlanItem].self, from: data)
        } catch {
            print("Load error:", error)
            items = []
        }
    }
}
