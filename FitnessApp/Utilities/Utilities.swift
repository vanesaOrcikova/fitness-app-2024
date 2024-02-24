import Foundation

class Utilities {

   static func generateRandomIndex(excluding currentIndex: Int, in range: Range<Int>) -> Int {
        guard range.count > 1 else { return currentIndex } // Return current if range is too small

        var newIndex: Int
        repeat {
            newIndex = Int.random(in: range)
        } while newIndex == currentIndex

        return newIndex
    }
}

//Tento kód definuje triedu Utilities v jazyku Swift, ktorá obsahuje statickú metódu generateRandomIndex. Táto metóda generuje náhodný index v danom rozsahu, pričom vylučuje aktuálny index (zadaný parametrom currentIndex). Ak je rozsah menší alebo rovný jednej, metóda vráti aktuálny index. V opačnom prípade opakovane generuje náhodné indexy v danom rozsahu, kým nenájde index odlišný od aktuálneho, a potom ho vráti. Táto funkcia je užitočná napríklad pre generovanie náhodných indexov v poli, pri vynechaní aktuálneho indexu.
