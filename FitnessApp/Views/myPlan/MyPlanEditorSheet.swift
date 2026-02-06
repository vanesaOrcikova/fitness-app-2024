//
//  MyPlanEditorSheet.swift
//  FitnessApp
//
//  Created by Vanesa Orcikova on 01/02/2026.
//

import SwiftUI

enum EditorMode { case add, edit }

struct PlanItemEditorSheet: View {

    let mode: EditorMode
    let accent: Color
    let accent2: Color
    let bg: Color
    let initialItem: PlanItem?
    let onSave: (PlanItem) -> Void

    @Environment(\.dismiss) private var dismiss

    @State private var title: String = ""
    @State private var note: String = ""

    @State private var section: PlanSection = .workout
    @State private var kind: PlanKind = .normal
    @State private var priority: PlanPriority = .medium

    @State private var hasStart: Bool = false
    @State private var hasEnd: Bool = false
    @State private var startTime: Date = Date()
    @State private var endTime: Date = Date()

    @State private var groceries: [GroceryItem] = []
    @State private var newGroceryName: String = ""

    var body: some View {
        ZStack {
            bg.ignoresSafeArea()

            VStack(spacing: 12) {

                HStack {
                    Text(mode == .add ? "Add item" : "Edit item")
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(.black.opacity(0.85))
                    Spacer()
                    Button { dismiss() } label: {
                        Image(systemName: "xmark")
                            .font(.system(size: 14, weight: .bold))
                            .foregroundColor(.black.opacity(0.7))
                            .padding(10)
                            .background(Color.white.opacity(0.95))
                            .clipShape(Circle())
                    }
                }
                .padding(.horizontal, 16)
                .padding(.top, 12)

                ScrollView(showsIndicators: false) {
                    VStack(alignment: .leading, spacing: 14) {

                        Text("Title")
                            .font(.system(size: 13, weight: .bold))
                            .foregroundColor(.black.opacity(0.65))

                        TextField("Write your plan…", text: $title)
                            .padding(14)
                            .background(Color.white.opacity(0.95))
                            .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))

                        Text("Note")
                            .font(.system(size: 13, weight: .bold))
                            .foregroundColor(.black.opacity(0.65))

                        TextEditor(text: $note)
                            .frame(minHeight: 90)
                            .padding(10)
                            .background(Color.white.opacity(0.95))
                            .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))

                        Text("Section")
                            .font(.system(size: 13, weight: .bold))
                            .foregroundColor(.black.opacity(0.65))

                        Picker("", selection: $section) {
                            ForEach(PlanSection.allCases, id: \.self) { s in
                                Text(s.rawValue).tag(s)
                            }
                        }
                        .pickerStyle(.segmented)
                        .onChange(of: section) { newValue in
                            if newValue == .workout {
                                kind = .normal
                                groceries = []
                            }
                        }

                        if section == .workout {
                            Text("Priority")
                                .font(.system(size: 13, weight: .bold))
                                .foregroundColor(.black.opacity(0.65))

                            Picker("", selection: $priority) {
                                ForEach(PlanPriority.allCases, id: \.self) { p in
                                    Text(p.rawValue).tag(p)
                                }
                            }
                            .pickerStyle(.segmented)
                        } else {
                            Text("Type")
                                .font(.system(size: 13, weight: .bold))
                                .foregroundColor(.black.opacity(0.65))

                            Picker("", selection: $kind) {
                                Text(PlanKind.normal.rawValue).tag(PlanKind.normal)
                                Text(PlanKind.shopping.rawValue).tag(PlanKind.shopping)
                            }
                            .pickerStyle(.segmented)
                            .onChange(of: kind) { newValue in
                                if newValue != .shopping { groceries = [] }
                            }
                        }

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

                        if section == .meal && kind == .shopping {
                            groceriesEditor
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.bottom, 18)
                }

                Button { saveTapped() } label: {
                    Text(mode == .add ? "Add" : "Save")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 14)
                        .background(
                            LinearGradient(colors: [accent, accent2],
                                           startPoint: .leading,
                                           endPoint: .trailing)
                        )
                        .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
                        .shadow(radius: 10, y: 4)
                }
                .padding(.horizontal, 16)
                .padding(.bottom, 10)
            }
        }
        .onAppear { fillFields() }
        .presentationDetents([.large])
    }

    private var groceriesEditor: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Groceries")
                .font(.system(size: 13, weight: .bold))
                .foregroundColor(.black.opacity(0.65))

            HStack(spacing: 10) {
                TextField("Add food item…", text: $newGroceryName)
                    .padding(12)
                    .background(Color.white.opacity(0.95))
                    .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))

                Button {
                    let t = newGroceryName.trimmingCharacters(in: .whitespacesAndNewlines)
                    if t.isEmpty { return }
                    groceries.insert(GroceryItem(name: t, isDone: false), at: 0)
                    newGroceryName = ""
                } label: {
                    Image(systemName: "plus")
                        .font(.system(size: 14, weight: .bold))
                        .foregroundColor(.white)
                        .padding(12)
                        .background(
                            LinearGradient(colors: [accent, accent2], startPoint: .leading, endPoint: .trailing)
                        )
                        .clipShape(Circle())
                }
            }

            if groceries.isEmpty {
                Text("Add foods you want to buy 💕")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundColor(.gray)
            } else {
                ForEach(groceries) { g in
                    HStack {
                        Text(g.name)
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundColor(.black.opacity(0.8))
                        Spacer()
                        Button {
                            groceries.removeAll { $0.id == g.id }
                        } label: {
                            Image(systemName: "trash")
                                .foregroundColor(.pink)
                        }
                    }
                    .padding(10)
                    .background(Color.white.opacity(0.9))
                    .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
                }
            }
        }
        .padding(12)
        .background(Color.white.opacity(0.85))
        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
    }

    private func fillFields() {
        if let item = initialItem {
            title = item.title
            note = item.note
            section = item.section
            kind = item.kind
            priority = item.priority
            groceries = item.groceries

            if section == .workout {
                kind = .normal
                groceries = []
            } else if kind != .shopping {
                groceries = []
            }

            if let st = item.startTime { hasStart = true; startTime = st }
            if let en = item.endTime { hasEnd = true; endTime = en }
        } else {
            title = ""
            note = ""
            section = .workout
            kind = .normal
            priority = .medium
            hasStart = false
            hasEnd = false
            groceries = []
            newGroceryName = ""
        }
    }

    private func saveTapped() {
        let t = title.trimmingCharacters(in: .whitespacesAndNewlines)
        if t.isEmpty { return }

        let baseId = initialItem?.id ?? UUID()
        let created = initialItem?.createdAt ?? Date()
        let done = initialItem?.isDone ?? false

        let finalStart = hasStart ? startTime : nil
        let finalEnd = hasEnd ? endTime : nil

        let finalKind: PlanKind = (section == .workout) ? .normal : kind
        let finalPriority: PlanPriority = (section == .workout) ? priority : .medium
        let finalGroceries: [GroceryItem] = (section == .meal && finalKind == .shopping) ? groceries : []

        let newItem = PlanItem(
            id: baseId,
            title: t,
            note: note,
            section: section,
            kind: finalKind,
            priority: finalPriority,
            startTime: finalStart,
            endTime: finalEnd,
            isDone: done,
            createdAt: created,
            groceries: finalGroceries
        )

        onSave(newItem)
        dismiss()
    }
}
