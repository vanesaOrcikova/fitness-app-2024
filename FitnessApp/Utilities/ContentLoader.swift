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

// Tento kód načíta .json súbor, ktorý máš uložený v projekte. Potom ho pomocou JSONDecoder premení na Swift typ (napríklad pole stringov alebo tvoju štruktúru). Ak súbor neexistuje alebo JSON nesedí so štruktúrou, vypíše error a vráti nil.
