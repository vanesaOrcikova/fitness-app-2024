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


//Tento kód definuje triedu WeeklyMoodOverviewTableReseter v jazyku Swift, ktorá slúži na periodické resetovanie týždennej prehľadovej tabuľky nálad. Trieda obsahuje metódu scheduleWeeklyReset, ktorá plánuje reset tabuľky na budúcu nedeľu pomocou Timer, a metódu resetWeek, ktorá vykoná samotný reset tabuľky a potom plánuje ďalší reset pre budúci týždeň. Metóda getNextResetTime vypočítava dátum a čas nasledujúcej nedele (polnoc), aby mohol byť reset plánovaný na tento čas. Trieda tiež obsahuje zdieľanú inštanciu shared, čo je konvenčný spôsob vytvorenia singletonu, teda inštancia, ktorá je zdieľaná naprieč celou aplikáciou.
