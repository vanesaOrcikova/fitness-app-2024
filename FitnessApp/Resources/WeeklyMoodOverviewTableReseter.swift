import Foundation
class WeeklyMoodOverviewTableReseter {
    static let shared = WeeklyMoodOverviewTableReseter()

    func checkAndResetIfNecessary() {
        let lastResetDate = UserDefaults.standard.object(forKey: "lastResetDate") as? Date ?? Date()
        let now = Date()
        let calendar = Calendar.current

        let lastResetDay = calendar.component(.weekday, from: lastResetDate)
        let today = calendar.component(.weekday, from: now)

        // Check if today is Sunday (by swift calendar sunday has index 1) and the last reset was not today
        if today == 1 && !calendar.isDateInToday(lastResetDate) {
            resetWeek()
        }
    }
    
    //func resetWeek()
     private func resetWeek() {
         UserDefaults.standard.set(Array(repeating: "", count: 7), forKey: "weeklyMoodOverviewTableStorage")
         UserDefaults.standard.set(Date(), forKey: "lastResetDate") // Update the last reset date
     }
}


