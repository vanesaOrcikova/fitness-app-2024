import Foundation

class Utilities {

   static func generateRandomIndex(excluding currentIndex: Int, in range: Range<Int>) -> Int {
        guard range.count > 1 else { return currentIndex }

        var newIndex: Int
        repeat {
            newIndex = Int.random(in: range)
        } while newIndex == currentIndex

        return newIndex
    }
}

// Táto funkcia ti vyberie náhodný index z rozsahu (napr. 0..<10), ale zabezpečí, že to nebude rovnaký index ako predtým. Čiže keď napríklad generuješ nové motivácie alebo emoji, nebude sa ti stále opakovať to isté.

