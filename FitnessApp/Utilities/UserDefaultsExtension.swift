import Foundation

extension UserDefaults {

    static let appGroupId = "group.com.vanesaorcik.fitnessapp"

    static var shared: UserDefaults {
        UserDefaults(suiteName: appGroupId) ?? .standard
    }

    // --- tvoje pôvodné ---
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

    // --- shared (App Group) ---
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

    // ✅ NOVÉ: posledne zvolený mood (pre widget)
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



//Tento kód rozširuje funkcionalitu triedy UserDefaults v jazyku Swift tak, že pridáva metódy setWeekArray a weekArray. Metóda setWeekArray umožňuje uloženie poľa reťazcov do užívateľských preferencií pod daným kľúčom, pričom pole je pred uložením zakódované do formátu JSON. Metóda weekArray potom slúži na načítanie uloženého poľa reťazcov z užívateľských preferencií pre daný kľúč, pričom dekóduje dáta z formátu JSON späť do poľa reťazcov. V prípade, že žiadne dáta nie sú k dispozícii pre daný kľúč, alebo dekódovanie zlyhá, je vrátené pole s prázdnymi reťazcami. Tieto rozšírenia sú užitočné pre ukladanie a načítanie štruktúrovaných dát v užívateľských preferenciách s využitím formátu JSON.
