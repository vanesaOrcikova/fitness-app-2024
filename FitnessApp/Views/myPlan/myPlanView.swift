import SwiftUI
import UIKit

// MARK: - Models

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

    var kind: PlanKind
    var priority: PlanPriority

    // time range (optional)
    var startTime: Date?
    var endTime: Date?

    var isDone: Bool
    var createdAt: Date

    // only used if kind == .shopping
    var groceries: [GroceryItem]
}

// MARK: - Storage (UserDefaults)

final class MyPlanStore: ObservableObject {

    @Published var items: [PlanItem] = []

    // streak
    @Published var currentStreak: Int = 0
    @Published var lastCompletionDay: Date? = nil

    private let storageKey = "myPlanItemsStorage_v2"

    private let streakKey = "myPlan_currentStreak_v1"
    private let lastDayKey = "myPlan_lastCompletionDay_v1"

    init() {
        load()
        loadStreak()
    }

    // MARK: - Today progress helpers

    var todayDoneCount: Int { items.filter { $0.isDone }.count }
    var todayTotalCount: Int { items.count }

    var isPerfectDay: Bool {
        todayTotalCount > 0 && todayDoneCount == todayTotalCount
    }

    // MARK: - CRUD

    func add(item: PlanItem) {
        items.insert(item, at: 0)
        save()
    }

    /// Returns true if the item became DONE (useful for glow/haptic)
    @discardableResult
    func toggleDone(_ item: PlanItem) -> Bool {
        if let idx = index(of: item) {
            items[idx].isDone.toggle()
            let isNowDone = items[idx].isDone

            if isNowDone {
                registerTodayCompletionIfNeeded()
            }

            save()
            return isNowDone
        }
        return false
    }

    func update(_ item: PlanItem, updated: PlanItem) {
        if let idx = index(of: item) {
            items[idx] = updated
            save()
        }
    }

    func delete(_ item: PlanItem) {
        items.removeAll { $0.id == item.id }
        save()
    }

    // MARK: - Groceries

    func addGrocery(to item: PlanItem, name: String) {
        let trimmed = name.trimmingCharacters(in: .whitespacesAndNewlines)
        if trimmed.isEmpty { return }
        if let idx = index(of: item) {
            items[idx].groceries.insert(GroceryItem(name: trimmed, isDone: false), at: 0)
            save()
        }
    }

    func toggleGrocery(to item: PlanItem, grocery: GroceryItem) {
        if let idx = index(of: item) {
            if let gIdx = items[idx].groceries.firstIndex(where: { $0.id == grocery.id }) {
                items[idx].groceries[gIdx].isDone.toggle()
                save()
            }
        }
    }

    func deleteGrocery(from item: PlanItem, grocery: GroceryItem) {
        if let idx = index(of: item) {
            items[idx].groceries.removeAll { $0.id == grocery.id }
            save()
        }
    }

    // MARK: - Helpers

    private func index(of item: PlanItem) -> Int? {
        items.firstIndex(where: { $0.id == item.id })
    }

    // MARK: - Streak logic

    private func registerTodayCompletionIfNeeded() {
        let cal = Calendar.current
        let todayStart = cal.startOfDay(for: Date())

        // first ever completion
        guard let lastDay = lastCompletionDay else {
            currentStreak = 1
            lastCompletionDay = todayStart
            saveStreak()
            return
        }

        // already counted today
        if cal.isDate(lastDay, inSameDayAs: todayStart) {
            return
        }

        // if last completion was yesterday -> streak + 1
        if let yesterday = cal.date(byAdding: .day, value: -1, to: todayStart),
           cal.isDate(lastDay, inSameDayAs: yesterday) {
            currentStreak += 1
        } else {
            // otherwise reset to 1
            currentStreak = 1
        }

        lastCompletionDay = todayStart
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

    // MARK: - Persistence

    private func save() {
        do {
            let data = try JSONEncoder().encode(items)
            UserDefaults.standard.set(data, forKey: storageKey)
        } catch {
            print("MyPlanStore save error:", error)
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
            print("MyPlanStore load error:", error)
            items = []
        }
    }
}

// MARK: - Main View

struct myPlanView: View {

    @StateObject private var store = MyPlanStore()

    // Add/Edit sheets
    @State private var showAddSheet = false
    @State private var editingItem: PlanItem? = nil

    // Glow animation
    @State private var showGlow = false

    // Palette (same vibe as Recipes/Workouts)
    private let bg = Color(red: 1.0, green: 0.97, blue: 0.99)
    private let accent = Color(red: 0.85, green: 0.20, blue: 0.70)
    private let accent2 = Color(red: 0.98, green: 0.67, blue: 0.83)
    private let card = Color.white.opacity(0.9)

    var body: some View {
        ZStack {
            bg.ignoresSafeArea()

            ScrollView(showsIndicators: false) {
                VStack(spacing: 12) {

                    // HEADER
                    VStack(spacing: 6) {
                        Text("My Plan")
                            .font(.system(size: 26, weight: .bold))
                            .foregroundColor(.white)

                        Text("Your daily goals ✨")
                            .font(.system(size: 13, weight: .semibold))
                            .foregroundColor(.white.opacity(0.9))

                        HStack(spacing: 10) {
                            Text("Streak: \(store.currentStreak) 🔥")
                                .font(.system(size: 12, weight: .bold))
                                .foregroundColor(.white.opacity(0.95))

                            Text("Today: \(store.todayDoneCount)/\(store.todayTotalCount) ✨")
                                .font(.system(size: 12, weight: .bold))
                                .foregroundColor(.white.opacity(0.95))

                            if store.isPerfectDay {
                                Text("Perfect day 💗")
                                    .font(.system(size: 12, weight: .bold))
                                    .foregroundColor(.white)
                                    .padding(.horizontal, 10)
                                    .padding(.vertical, 6)
                                    .background(Color.white.opacity(0.22))
                                    .clipShape(Capsule())
                            }
                        }
                        .padding(.top, 4)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 18)
                    .background(
                        LinearGradient(
                            colors: [accent, accent2],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .clipShape(RoundedRectangle(cornerRadius: 26, style: .continuous))
                    .shadow(radius: 10, y: 4)
                    .padding(.horizontal, 14)
                    .padding(.top, -100)

                    // ADD button
                    Button {
                        showAddSheet = true
                    } label: {
                        HStack {
                            Image(systemName: "plus")
                                .font(.system(size: 16, weight: .bold))
                                .foregroundColor(.white)

                            Text("Add new item")
                                .font(.system(size: 15, weight: .bold))
                                .foregroundColor(.white)

                            Spacer()
                        }
                        .padding(.horizontal, 16)
                        .padding(.vertical, 14)
                        .background(
                            LinearGradient(colors: [accent, accent2], startPoint: .leading, endPoint: .trailing)
                        )
                        .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
                        .shadow(radius: 10, y: 4)
                    }
                    .padding(.horizontal, 14)

                    // LIST
                    VStack(spacing: 12) {
                        if store.items.isEmpty {
                            EmptyStateCard(card: card)
                        } else {
                            ForEach(store.items) { item in
                                PlanRow(
                                    item: item,
                                    accent: accent,
                                    accent2: accent2,
                                    card: card,
                                    onToggleDone: {
                                        let isNowDone = store.toggleDone(item)
                                        if isNowDone {
                                            // haptic
                                            let gen = UIImpactFeedbackGenerator(style: .light)
                                            gen.impactOccurred()

                                            // glow
                                            withAnimation(.spring(response: 0.35, dampingFraction: 0.6)) {
                                                showGlow = true
                                            }
                                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
                                                withAnimation(.easeOut(duration: 0.25)) {
                                                    showGlow = false
                                                }
                                            }
                                        }
                                    },
                                    onEdit: { editingItem = item },
                                    onDelete: { store.delete(item) },
                                    onToggleGrocery: { grocery in
                                        store.toggleGrocery(to: item, grocery: grocery)
                                    }
                                )
                            }
                        }
                    }
                    .padding(.horizontal, 14)
                    .padding(.bottom, 24)
                }
                .padding(.top, 6)
            }

            // Daily glow overlay
            if showGlow {
                Text("✨")
                    .font(.system(size: 80, weight: .bold))
                    .foregroundColor(accent2.opacity(0.95))
                    .transition(.scale.combined(with: .opacity))
                    .shadow(radius: 10)
            }
        }
        // ADD
        .sheet(isPresented: $showAddSheet) {
            PlanItemEditorSheet(
                mode: .add,
                accent: accent,
                accent2: accent2,
                bg: bg,
                initialItem: nil
            ) { newItem in
                store.add(item: newItem)
                showAddSheet = false
            }
        }
        // EDIT
        .sheet(item: $editingItem) { item in
            PlanItemEditorSheet(
                mode: .edit,
                accent: accent,
                accent2: accent2,
                bg: bg,
                initialItem: item
            ) { updated in
                store.update(item, updated: updated)
                editingItem = nil
            }
        }
    }
}

// MARK: - Row Card

private struct PlanRow: View {

    let item: PlanItem
    let accent: Color
    let accent2: Color
    let card: Color

    let onToggleDone: () -> Void
    let onEdit: () -> Void
    let onDelete: () -> Void
    let onToggleGrocery: (GroceryItem) -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {

            HStack(spacing: 12) {
                Button(action: onToggleDone) {
                    Image(systemName: item.isDone ? "checkmark.circle.fill" : "circle")
                        .font(.system(size: 22, weight: .bold))
                        .foregroundColor(item.isDone ? accent : .gray.opacity(0.6))
                }
                .buttonStyle(.plain)

                VStack(alignment: .leading, spacing: 4) {
                    Text(item.title)
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(.black.opacity(0.85))
                        .strikethrough(item.isDone, color: accent.opacity(0.8))
                        .opacity(item.isDone ? 0.6 : 1.0)

                    if !item.note.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                        Text(item.note)
                            .font(.system(size: 13, weight: .semibold))
                            .foregroundColor(.black.opacity(0.60))
                            .lineLimit(2)
                    }
                }

                Spacer()

                Button(action: onEdit) {
                    Image(systemName: "pencil")
                        .font(.system(size: 15, weight: .bold))
                        .foregroundColor(.black.opacity(0.55))
                        .padding(10)
                        .background(Color.white.opacity(0.95))
                        .clipShape(Circle())
                        .shadow(radius: 6, y: 2)
                }
                .buttonStyle(.plain)

                Button(action: onDelete) {
                    Image(systemName: "trash")
                        .font(.system(size: 15, weight: .bold))
                        .foregroundColor(.pink)
                        .padding(10)
                        .background(Color.white.opacity(0.95))
                        .clipShape(Circle())
                        .shadow(radius: 6, y: 2)
                }
                .buttonStyle(.plain)
            }

            // tags row: kind + priority + time
            HStack(spacing: 8) {
                TagChip(text: item.kind.rawValue, accent: accent, accent2: accent2)
                TagChip(text: "Priority: \(item.priority.rawValue)", accent: accent, accent2: accent2)

                if let start = item.startTime, let end = item.endTime {
                    TagChip(text: "\(timeText(start))–\(timeText(end))", accent: accent, accent2: accent2)
                } else if let start = item.startTime {
                    TagChip(text: "From \(timeText(start))", accent: accent, accent2: accent2)
                } else if let end = item.endTime {
                    TagChip(text: "Until \(timeText(end))", accent: accent, accent2: accent2)
                }

                Spacer()
            }

            // groceries list if shopping
            if item.kind == .shopping {
                if item.groceries.isEmpty {
                    Text("No groceries yet. Edit → add items 💕")
                        .font(.system(size: 13, weight: .semibold))
                        .foregroundColor(.gray)
                } else {
                    VStack(alignment: .leading, spacing: 8) {
                        ForEach(item.groceries) { g in
                            Button {
                                onToggleGrocery(g)
                            } label: {
                                HStack(spacing: 10) {
                                    Image(systemName: g.isDone ? "checkmark.circle.fill" : "circle")
                                        .foregroundColor(g.isDone ? accent : .gray.opacity(0.6))

                                    Text(g.name)
                                        .font(.system(size: 14, weight: .semibold))
                                        .foregroundColor(.black.opacity(0.75))
                                        .strikethrough(g.isDone, color: accent.opacity(0.8))
                                        .opacity(g.isDone ? 0.6 : 1.0)

                                    Spacer()
                                }
                            }
                            .buttonStyle(.plain)
                        }
                    }
                    .padding(.top, 6)
                }
            }
        }
        .padding(14)
        .background(card)
        .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
        .shadow(radius: 8, y: 3)
    }

    private func timeText(_ date: Date) -> String {
        let f = DateFormatter()
        f.dateFormat = "HH:mm"
        return f.string(from: date)
    }
}

private struct TagChip: View {
    let text: String
    let accent: Color
    let accent2: Color

    var body: some View {
        Text(text)
            .font(.system(size: 11, weight: .bold))
            .foregroundColor(accent)
            .padding(.horizontal, 10)
            .padding(.vertical, 6)
            .background(
                LinearGradient(
                    colors: [accent.opacity(0.12), accent2.opacity(0.12)],
                    startPoint: .leading,
                    endPoint: .trailing
                )
            )
            .clipShape(Capsule())
    }
}

// MARK: - Empty State

private struct EmptyStateCard: View {
    let card: Color

    var body: some View {
        VStack(spacing: 10) {
            Text("No plan items yet ✨")
                .font(.system(size: 16, weight: .bold))
                .foregroundColor(.black.opacity(0.8))

            Text("Tap “Add new item” to create your first goal.")
                .font(.system(size: 13, weight: .semibold))
                .foregroundColor(.black.opacity(0.55))
                .multilineTextAlignment(.center)
        }
        .padding(18)
        .frame(maxWidth: .infinity)
        .background(card)
        .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
        .shadow(radius: 8, y: 3)
    }
}

// MARK: - Editor Sheet

private enum EditorMode {
    case add
    case edit
}

private struct PlanItemEditorSheet: View {

    let mode: EditorMode
    let accent: Color
    let accent2: Color
    let bg: Color
    let initialItem: PlanItem?

    let onSave: (PlanItem) -> Void

    @Environment(\.dismiss) private var dismiss

    // fields
    @State private var title: String = ""
    @State private var note: String = ""

    @State private var kind: PlanKind = .normal
    @State private var priority: PlanPriority = .medium

    @State private var hasStart: Bool = false
    @State private var hasEnd: Bool = false
    @State private var startTime: Date = Date()
    @State private var endTime: Date = Date()

    // groceries (for shopping)
    @State private var groceries: [GroceryItem] = []
    @State private var newGroceryName: String = ""

    var body: some View {
        ZStack {
            bg.ignoresSafeArea()

            VStack(spacing: 12) {

                // header
                HStack {
                    Text(mode == .add ? "Add item" : "Edit item")
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(.black.opacity(0.85))
                    Spacer()
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark")
                            .font(.system(size: 14, weight: .bold))
                            .foregroundColor(.black.opacity(0.7))
                            .padding(10)
                            .background(Color.white.opacity(0.95))
                            .clipShape(Circle())
                            .shadow(radius: 6, y: 2)
                    }
                }
                .padding(.horizontal, 16)
                .padding(.top, 12)

                ScrollView(showsIndicators: false) {
                    VStack(alignment: .leading, spacing: 14) {

                        // Title
                        Text("Title")
                            .font(.system(size: 13, weight: .bold))
                            .foregroundColor(.black.opacity(0.65))

                        TextField("Write your plan…", text: $title)
                            .padding(14)
                            .background(Color.white.opacity(0.95))
                            .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                            .shadow(radius: 8, y: 3)

                        // Note
                        Text("Note (always shown on top)")
                            .font(.system(size: 13, weight: .bold))
                            .foregroundColor(.black.opacity(0.65))

                        TextEditor(text: $note)
                            .frame(minHeight: 90)
                            .padding(10)
                            .background(Color.white.opacity(0.95))
                            .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                            .shadow(radius: 8, y: 3)

                        // Kind + Priority
                        HStack(spacing: 12) {
                            VStack(alignment: .leading, spacing: 6) {
                                Text("Type")
                                    .font(.system(size: 13, weight: .bold))
                                    .foregroundColor(.black.opacity(0.65))
                                Picker("", selection: $kind) {
                                    ForEach(PlanKind.allCases, id: \.self) { k in
                                        Text(k.rawValue).tag(k)
                                    }
                                }
                                .pickerStyle(.segmented)
                            }

                            VStack(alignment: .leading, spacing: 6) {
                                Text("Priority")
                                    .font(.system(size: 13, weight: .bold))
                                    .foregroundColor(.black.opacity(0.65))
                                Picker("", selection: $priority) {
                                    ForEach(PlanPriority.allCases, id: \.self) { p in
                                        Text(p.rawValue).tag(p)
                                    }
                                }
                                .pickerStyle(.segmented)
                            }
                        }

                        // Time range
                        Text("Time")
                            .font(.system(size: 13, weight: .bold))
                            .foregroundColor(.black.opacity(0.65))

                        VStack(spacing: 10) {
                            Toggle("Start time", isOn: $hasStart)
                                .font(.system(size: 14, weight: .semibold))

                            if hasStart {
                                DatePicker("", selection: $startTime, displayedComponents: .hourAndMinute)
                                    .datePickerStyle(.wheel)
                                    .labelsHidden()
                                    .frame(maxWidth: .infinity)
                                    .background(Color.white.opacity(0.95))
                                    .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                            }

                            Toggle("End time", isOn: $hasEnd)
                                .font(.system(size: 14, weight: .semibold))

                            if hasEnd {
                                DatePicker("", selection: $endTime, displayedComponents: .hourAndMinute)
                                    .datePickerStyle(.wheel)
                                    .labelsHidden()
                                    .frame(maxWidth: .infinity)
                                    .background(Color.white.opacity(0.95))
                                    .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                            }
                        }
                        .padding(12)
                        .background(Color.white.opacity(0.85))
                        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                        .shadow(radius: 8, y: 3)

                        // Groceries if shopping
                        if kind == .shopping {
                            Text("Groceries")
                                .font(.system(size: 13, weight: .bold))
                                .foregroundColor(.black.opacity(0.65))

                            VStack(spacing: 10) {

                                HStack(spacing: 10) {
                                    TextField("Add food item…", text: $newGroceryName)
                                        .padding(12)
                                        .background(Color.white.opacity(0.95))
                                        .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))

                                    Button {
                                        let trimmed = newGroceryName.trimmingCharacters(in: .whitespacesAndNewlines)
                                        if !trimmed.isEmpty {
                                            groceries.insert(GroceryItem(name: trimmed, isDone: false), at: 0)
                                            newGroceryName = ""
                                        }
                                    } label: {
                                        Image(systemName: "plus")
                                            .font(.system(size: 14, weight: .bold))
                                            .foregroundColor(.white)
                                            .padding(12)
                                            .background(
                                                LinearGradient(colors: [accent, accent2], startPoint: .leading, endPoint: .trailing)
                                            )
                                            .clipShape(Circle())
                                            .shadow(radius: 6, y: 2)
                                    }
                                }

                                if groceries.isEmpty {
                                    Text("Add foods you want to buy 💕")
                                        .font(.system(size: 13, weight: .semibold))
                                        .foregroundColor(.gray)
                                        .padding(.top, 4)
                                } else {
                                    VStack(spacing: 8) {
                                        ForEach(groceries) { g in
                                            HStack(spacing: 10) {
                                                Button {
                                                    if let idx = groceries.firstIndex(where: { $0.id == g.id }) {
                                                        groceries[idx].isDone.toggle()
                                                    }
                                                } label: {
                                                    Image(systemName: g.isDone ? "checkmark.circle.fill" : "circle")
                                                        .foregroundColor(g.isDone ? accent : .gray.opacity(0.6))
                                                }
                                                .buttonStyle(.plain)

                                                Text(g.name)
                                                    .font(.system(size: 14, weight: .semibold))
                                                    .foregroundColor(.black.opacity(0.75))
                                                    .strikethrough(g.isDone, color: accent.opacity(0.8))
                                                    .opacity(g.isDone ? 0.6 : 1.0)

                                                Spacer()

                                                Button {
                                                    groceries.removeAll { $0.id == g.id }
                                                } label: {
                                                    Image(systemName: "trash")
                                                        .foregroundColor(.pink)
                                                }
                                                .buttonStyle(.plain)
                                            }
                                            .padding(10)
                                            .background(Color.white.opacity(0.9))
                                            .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
                                            .shadow(radius: 6, y: 2)
                                        }
                                    }
                                    .padding(.top, 4)
                                }
                            }
                            .padding(12)
                            .background(Color.white.opacity(0.85))
                            .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                            .shadow(radius: 8, y: 3)
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.bottom, 18)
                }

                // SAVE button
                Button {
                    let trimmedTitle = title.trimmingCharacters(in: .whitespacesAndNewlines)
                    if trimmedTitle.isEmpty { return }

                    let finalStart = hasStart ? startTime : nil
                    let finalEnd = hasEnd ? endTime : nil

                    let baseId = initialItem?.id ?? UUID()
                    let created = initialItem?.createdAt ?? Date()
                    let done = initialItem?.isDone ?? false

                    let finalGroceries = (kind == .shopping) ? groceries : []

                    let newItem = PlanItem(
                        id: baseId,
                        title: trimmedTitle,
                        note: note,
                        kind: kind,
                        priority: priority,
                        startTime: finalStart,
                        endTime: finalEnd,
                        isDone: done,
                        createdAt: created,
                        groceries: finalGroceries
                    )

                    onSave(newItem)
                    dismiss()
                } label: {
                    Text(mode == .add ? "Add" : "Save")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 14)
                        .background(
                            LinearGradient(colors: [accent, accent2], startPoint: .leading, endPoint: .trailing)
                        )
                        .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
                        .shadow(radius: 10, y: 4)
                }
                .padding(.horizontal, 16)
                .padding(.bottom, 10)
            }
        }
        .onAppear {
            if let item = initialItem {
                title = item.title
                note = item.note
                kind = item.kind
                priority = item.priority

                if let st = item.startTime {
                    hasStart = true
                    startTime = st
                } else {
                    hasStart = false
                }

                if let en = item.endTime {
                    hasEnd = true
                    endTime = en
                } else {
                    hasEnd = false
                }

                groceries = item.groceries
            } else {
                title = ""
                note = ""
                kind = .normal
                priority = .medium
                hasStart = false
                hasEnd = false
                groceries = []
                newGroceryName = ""
            }
        }
        .presentationDetents([.large])
    }
}

#Preview {
    myPlanView()
}
