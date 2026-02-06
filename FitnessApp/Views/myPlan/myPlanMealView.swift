//
//  myPlanMealView.swift
//  FitnessApp
//
//  Created by Vanesa Orcikova on 01/02/2026.
//

import SwiftUI

struct myPlanMealView: View {

    let items: [PlanItem]
    let accent: Color
    let accent2: Color
    let card: Color

    let onToggleDone: (PlanItem) -> Void
    let onEdit: (PlanItem) -> Void
    let onDelete: (PlanItem) -> Void
    let onToggleGrocery: (PlanItem, GroceryItem) -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {

            HStack {
                Text("Blog 🍓")
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(.black.opacity(0.85))

                Spacer()

                Text("\(items.filter { $0.isDone }.count)/\(items.count)")
                    .font(.system(size: 12, weight: .bold))
                    .foregroundColor(.black.opacity(0.55))
                    .padding(.horizontal, 10)
                    .padding(.vertical, 6)
                    .background(Color.white.opacity(0.8))
                    .clipShape(Capsule())
            }

            if items.isEmpty {
                Text("Nothing here yet ✨")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundColor(.black.opacity(0.55))
                    .padding(14)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(card)
                    .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
                    .shadow(radius: 8, y: 3)
            } else {
                ForEach(items) { item in
                    MealRow(
                        item: item,
                        accent: accent,
                        accent2: accent2,
                        card: card,
                        onToggleDone: { onToggleDone(item) },
                        onEdit: { onEdit(item) },
                        onDelete: { onDelete(item) },
                        onToggleGrocery: { g in onToggleGrocery(item, g) }
                    )
                }
            }
        }
        .padding(.top, 4)
    }
}

private struct MealRow: View {

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
                }
                .buttonStyle(.plain)

                Button(action: onDelete) {
                    Image(systemName: "trash")
                        .font(.system(size: 15, weight: .bold))
                        .foregroundColor(.pink)
                        .padding(10)
                        .background(Color.white.opacity(0.95))
                        .clipShape(Circle())
                }
                .buttonStyle(.plain)
            }

            // Blog: show kind only (NO priority)
            HStack(spacing: 8) {
                TagChip(text: item.kind.rawValue, accent: accent, accent2: accent2)

                if let start = item.startTime, let end = item.endTime {
                    TagChip(text: "\(timeText(start))–\(timeText(end))", accent: accent, accent2: accent2)
                } else if let start = item.startTime {
                    TagChip(text: "From \(timeText(start))", accent: accent, accent2: accent2)
                } else if let end = item.endTime {
                    TagChip(text: "Until \(timeText(end))", accent: accent, accent2: accent2)
                }

                Spacer()
            }

            // groceries only for shopping
            if item.kind == PlanKind.shopping {
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
