import WidgetKit
import SwiftUI

// MARK: - Entry

struct SimpleEntry: TimelineEntry {
    let date: Date
    let moodEmoji: String
}

// MARK: - Provider

struct Provider: TimelineProvider {

    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), moodEmoji: "😎")
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> Void) {
        completion(makeEntry())
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<SimpleEntry>) -> Void) {
        let entry = makeEntry()
        let next = Calendar.current.date(byAdding: .minute, value: 30, to: Date()) ?? Date().addingTimeInterval(1800)
        completion(Timeline(entries: [entry], policy: .after(next)))
    }

    private func makeEntry() -> SimpleEntry {
        let defaults = UserDefaults(suiteName: "group.com.vanesaorcik.fitnessapp") ?? .standard

        // 1) načítaj celý týždeň (shared)
        var weekArr: [String] = Array(repeating: "", count: 7)
        if let data = defaults.data(forKey: "weeklyMoodOverviewTableStorage"),
           let arr = try? JSONDecoder().decode([String].self, from: data),
           arr.count == 7 {
            weekArr = arr
        }

        // 2) skús dnešný emoji (Mon=0...Sun=6)
        let todayIdx = todayIndexMonFirst()
        let todayEmoji = (weekArr.indices.contains(todayIdx) && !weekArr[todayIdx].trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
            ? weekArr[todayIdx]
            : nil

        // 3) ak dnešný nie je, použi posledne zvolený (tvoj "ako chcem" mód)
        let lastEmoji = defaults.string(forKey: "healthyMe_lastMoodEmoji_v1")
        var finalEmoji = todayEmoji ?? "✨"

        if todayEmoji == nil {
            if let le = lastEmoji, !le.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                finalEmoji = le
            } else {
                // fallback: nájdi posledný vyplnený v týždni
                if let found = findLastNonEmpty(weekArr) {
                    finalEmoji = found
                }
            }
        }

        return SimpleEntry(date: Date(), moodEmoji: finalEmoji)
    }

    // Calendar weekday: 1=Sun,2=Mon,...7=Sat -> Mon=0...Sun=6
    private func todayIndexMonFirst() -> Int {
        let w = Calendar.current.component(.weekday, from: Date())
        return (w == 1) ? 6 : (w - 2)
    }

    private func findLastNonEmpty(_ arr: [String]) -> String? {
        if arr.count < 7 { return nil }
        for i in stride(from: 6, through: 0, by: -1) {
            let e = arr[i].trimmingCharacters(in: .whitespacesAndNewlines)
            if !e.isEmpty { return e }
        }
        return nil
    }
}

// MARK: - View

struct HealthyMeWidgetEntryView: View {
    var entry: Provider.Entry

    // ružové pozadie ako v appke
    private let pink = Color(red: 0.85, green: 0.20, blue: 0.70)
    private let pink2 = Color(red: 0.98, green: 0.67, blue: 0.83)

    var body: some View {
        VStack(spacing: 10) {
            Text("Healthy Me ✨")
                .font(.system(size: 14, weight: .bold))
                .foregroundColor(.white)
                .frame(maxWidth: .infinity, alignment: .leading)

            Text("My mood for today:")
                .font(.system(size: 12, weight: .semibold))
                .foregroundColor(.white.opacity(0.92))
                .frame(maxWidth: .infinity, alignment: .leading)

            Spacer(minLength: 2)

            Text(entry.moodEmoji)
                .font(.system(size: 54))

            Spacer(minLength: 6)
        }
        .padding(12)
    }
}

// MARK: - Widget

struct HealthyMeWidget: Widget {
    let kind: String = "HealthyMeWidget"

    // ružové pozadie
    private let pink = Color(red: 0.85, green: 0.20, blue: 0.70)
    private let pink2 = Color(red: 0.98, green: 0.67, blue: 0.83)

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            if #available(iOS 17.0, *) {
                HealthyMeWidgetEntryView(entry: entry)
                    // ✅ ružový gradient na celý widget
                    .containerBackground(for: .widget) {
                        LinearGradient(
                            colors: [pink, pink2],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    }
            } else {
                // Pre staršie iOS verzie
                ZStack {
                    LinearGradient(
                        colors: [pink, pink2],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                    HealthyMeWidgetEntryView(entry: entry)
                }
            }
        }
        .configurationDisplayName("Healthy Me ✨")
        .description("Shows your mood.")
        .supportedFamilies([.systemSmall])
    }
}

#Preview(as: .systemSmall) {
    HealthyMeWidget()
} timeline: {
    SimpleEntry(date: .now, moodEmoji: "😎")
    SimpleEntry(date: .now, moodEmoji: "😍")
}
