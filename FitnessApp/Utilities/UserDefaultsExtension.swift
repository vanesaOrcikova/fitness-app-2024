import Foundation
extension UserDefaults {
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
}

//Tento kód rozširuje funkcionalitu triedy UserDefaults v jazyku Swift tak, že pridáva metódy setWeekArray a weekArray. Metóda setWeekArray umožňuje uloženie poľa reťazcov do užívateľských preferencií pod daným kľúčom, pričom pole je pred uložením zakódované do formátu JSON. Metóda weekArray potom slúži na načítanie uloženého poľa reťazcov z užívateľských preferencií pre daný kľúč, pričom dekóduje dáta z formátu JSON späť do poľa reťazcov. V prípade, že žiadne dáta nie sú k dispozícii pre daný kľúč, alebo dekódovanie zlyhá, je vrátené pole s prázdnymi reťazcami. Tieto rozšírenia sú užitočné pre ukladanie a načítanie štruktúrovaných dát v užívateľských preferenciách s využitím formátu JSON.
