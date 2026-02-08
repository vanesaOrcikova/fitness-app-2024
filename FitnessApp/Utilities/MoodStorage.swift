//
//  MoodStorage.swift
//  FitnessApp
//
//  Created by Vanesa Orcikova on 31/01/2026.
//

import Foundation
import WidgetKit

final class MoodStorage {
    static let shared = MoodStorage()

    private let appGroupId = "group.com.vanesaorcik.fitnessapp"
    private let moodKey = "healthyMe_todayMoodEmoji_v1"

    private var sharedDefaults: UserDefaults {
        UserDefaults(suiteName: appGroupId) ?? .standard
    }

    func saveTodayMood(_ emoji: String) {
        sharedDefaults.set(emoji, forKey: moodKey)
        WidgetCenter.shared.reloadAllTimelines()
    }
}

// Tento kód si pamätá emoji nálady. Keď user vyberie emoji, uloží sa do UserDefaults v App Groupe, takže ho vie použiť aj widget. A potom sa widget hneď obnoví, aby sa tam ukázala nová nálada.
