import Foundation
import SwiftUI

struct ReminderView: View {

    @State private var contentDataReminders: [HomeReminderModel]? = []

    private let accent = Color(red: 0.85, green: 0.20, blue: 0.70)
    private let accent2 = Color(red: 0.98, green: 0.67, blue: 0.83)

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {

            Text("Reminders")
                .font(.system(size: 18, weight: .bold))
                .foregroundColor(.black.opacity(0.85))

            let dayIndex = GlobalData.getCurrentDayIndex()

            if let reminders = contentDataReminders, !reminders.isEmpty {
                ReminderRow(text: reminders[dayIndex].reminder1)
                ReminderRow(text: reminders[dayIndex].reminder2)
                ReminderRow(text: reminders[dayIndex].reminder3)
            } else {
                Text("ERROR: No reminders available.")
                    .foregroundColor(.gray)
            }

        }
        .padding(16)
        .background(
            LinearGradient(colors: [accent.opacity(0.08), accent2.opacity(0.08)], startPoint: .topLeading, endPoint: .bottomTrailing)
        )
        .clipShape(RoundedRectangle(cornerRadius: 22, style: .continuous))
        .shadow(radius: 10, y: 4)
        .onAppear {
            contentDataReminders = ContentLoader.loadJSON(fileName: "ContentData/HomeReminder", type: [HomeReminderModel].self)
        }
    }
}

private struct ReminderRow: View {
    let text: String
    var body: some View {
        HStack(spacing: 10) {
            Image(systemName: "checkmark.circle.fill")
                .foregroundColor(.pink)
            Text(text)
                .font(.system(size: 14, weight: .semibold))
                .foregroundColor(.black.opacity(0.75))
            Spacer()
        }
        .padding(10)
        .background(Color.white.opacity(0.85))
        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
    }
}


