import Foundation
class WeeklyMoodOverviewTableReseter {
    static let shared = WeeklyMoodOverviewTableReseter()

    func scheduleWeeklyReset() {
        let nextResetTime = getNextResetTime()
        let timer = Timer(fireAt: nextResetTime, interval: 0, target: self, selector: #selector(resetWeek), userInfo: nil, repeats: false)
        RunLoop.main.add(timer, forMode: .common)
    }

    @objc private func resetWeek() {
        UserDefaults.standard.set(Array(repeating: "", count: 7), forKey: "weeklyMoodOverviewTableStorage")
        scheduleWeeklyReset() // Reschedule for next week
    }

    private func getNextResetTime() -> Date {
        var nextSunday = DateComponents()
        nextSunday.weekday = 1 // Sunday
        nextSunday.hour = 23   // Midnight
        nextSunday.minute = 59
        nextSunday.second = 59

        let calendar = Calendar.current
        let now = Date()
        return calendar.nextDate(after: now, matching: nextSunday, matchingPolicy: .nextTimePreservingSmallerComponents)!
    }
}


//import Foundation
//class WeeklyMoodOverviewTableReseter {
//    static let shared = WeeklyMoodOverviewTableReseter()
//
//    func scheduleWeeklyReset() {
//        let nextResetTime = getNextResetTime()
//        let timer = Timer(fireAt: nextResetTime, interval: 0, target: self, selector: #selector(resetWeek), userInfo: nil, repeats: false)
//        RunLoop.main.add(timer, forMode: .common)
//    }
//
//    @objc private func resetWeek() {
//        UserDefaults.standard.set(Array(repeating: "", count: 7), forKey: "weeklyMoodOverviewTableStorage")
//        scheduleWeeklyReset() // Reschedule for next week
//    }
//
//    private func getNextResetTime() -> Date {
//        var nextSunday = DateComponents()
//        nextSunday.weekday = 7
//        nextSunday.hour = 16
//        nextSunday.minute = 20
//        nextSunday.second = 0
//
//        let calendar = Calendar.current
//        let now = Date()
//        return calendar.nextDate(after: now, matching: nextSunday, matchingPolicy: .nextTimePreservingSmallerComponents)!
//    }
//}


//Tento kód definuje triedu WeeklyMoodOverviewTableReseter v jazyku Swift, ktorá slúži na periodické resetovanie týždennej prehľadovej tabuľky nálad. Trieda obsahuje metódu scheduleWeeklyReset, ktorá plánuje reset tabuľky na budúcu nedeľu pomocou Timer, a metódu resetWeek, ktorá vykoná samotný reset tabuľky a potom plánuje ďalší reset pre budúci týždeň. Metóda getNextResetTime vypočítava dátum a čas nasledujúcej nedele (polnoc), aby mohol byť reset plánovaný na tento čas. Trieda tiež obsahuje zdieľanú inštanciu shared, čo je konvenčný spôsob vytvorenia singletonu, teda inštancia, ktorá je zdieľaná naprieč celou aplikáciou.
