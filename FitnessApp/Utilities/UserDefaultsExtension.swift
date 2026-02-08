import Foundation

extension UserDefaults {

    static let appGroupId = "group.com.vanesaorcik.fitnessapp"

    static var shared: UserDefaults {
        UserDefaults(suiteName: appGroupId) ?? .standard
    }

    func setWeekArray(_ array: [String], forKey key: String) {
        let data = try? JSONEncoder().encode(array)
        self.set(data, forKey: key)
    }

    func weekArray(forKey key: String) -> [String] {
        guard let data = self.data(forKey: key),
              let array = try? JSONDecoder().decode([String].self, from: data) else {
            return Array(repeating: "", count: 7)
        }
        return array
    }

    func setWeekArrayShared(_ array: [String], forKey key: String) {
        let data = try? JSONEncoder().encode(array)
        UserDefaults.shared.set(data, forKey: key)
    }

    func weekArrayShared(forKey key: String) -> [String] {
        guard let data = UserDefaults.shared.data(forKey: key),
              let array = try? JSONDecoder().decode([String].self, from: data) else {
            return Array(repeating: "", count: 7)
        }
        return array
    }

    // NOVÉ: posledne zvolený mood (pre widget)
    func setLastMoodShared(emoji: String, dayIndex: Int) {
        UserDefaults.shared.set(emoji, forKey: "healthyMe_lastMoodEmoji_v1")
        UserDefaults.shared.set(dayIndex, forKey: "healthyMe_lastMoodDayIndex_v1")
        UserDefaults.shared.set(Date().timeIntervalSince1970, forKey: "healthyMe_lastMoodTimestamp_v1")
    }

    func getLastMoodShared() -> (emoji: String, dayIndex: Int, timestamp: Double)? {
        guard let emoji = UserDefaults.shared.string(forKey: "healthyMe_lastMoodEmoji_v1"),
              !emoji.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
        else { return nil }

        let idx = UserDefaults.shared.integer(forKey: "healthyMe_lastMoodDayIndex_v1")
        let ts = UserDefaults.shared.double(forKey: "healthyMe_lastMoodTimestamp_v1")
        return (emoji, idx, ts)
    }
}

// Tento súbor pridáva do UserDefaults vlastné funkcie, aby si vedela jednoducho ukladať a načítavať dáta. Vie uložiť a načítať array pre 7 dní (napr. plán, mood, texty). Máš tu aj verziu pre App Group, aby to vedel používať widget. Na konci sú funkcie na uloženie posledného mood emoji spolu s dňom a časom, aby widget vedel zobraziť poslednú náladu.


