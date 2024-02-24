import Foundation

class ContentLoader {

    static func loadJSON<T: Codable>(fileName: String, type: T.Type) -> T? {
        guard let url = Bundle.main.url(forResource: fileName, withExtension: "json") else {
            print("JSON file not found in the bundle")
            return nil
        }

        do {
            let data = try Data(contentsOf: url)
            let decoder = JSONDecoder()
            let jsonData = try decoder.decode(T.self, from: data)
            return jsonData
        } catch {
            print("Error decoding JSON: \(error)")
            return nil
        }
    }
}

//Tento kód je implementovaný v jazyku Swift a slúži na načítanie dát zo súborov vo formáte JSON. Funkcia loadJSON prijíma názov súboru a typ objektu, do ktorého sú údaje dekódované. Ak je súbor nájdený a údaje sú úspešne dekódované, funkcia vráti inštanciu daného objektu. V opačnom prípade vráti nil a vypíše chybu, ak súbor nie je nájdený alebo dekódovanie zlyhá. Táto funkcia je užitočná pre načítanie statických dát zo súborov JSON a ich následné spracovanie v aplikáciách v jazyku Swift.
