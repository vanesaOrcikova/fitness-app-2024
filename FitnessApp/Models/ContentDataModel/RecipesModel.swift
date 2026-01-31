import Foundation

struct RecipesModel: Codable {
    var id: Int

    var name: String
    var imgpath: String
    var difficulty: String
    var waitingtime: Int
    var cookingtime: Int
    var nutritions: String
    var description: String
    var recipesteps: String
    var ingredients: String
    var dietary: String
    var buttonimagepaths: String

    // ✅ viac kategórií naraz
    var category: [String]

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case imgpath
        case difficulty
        case waitingtime
        case cookingtime
        case nutritions
        case description
        case recipesteps
        case ingredients
        case dietary
        case buttonimagepaths
        case category
    }

    // ✅ tolerantné: category môže byť [String] alebo String alebo chýba
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        id = try container.decode(Int.self, forKey: .id)

        name = try container.decode(String.self, forKey: .name)
        imgpath = try container.decode(String.self, forKey: .imgpath)
        difficulty = try container.decode(String.self, forKey: .difficulty)
        waitingtime = try container.decode(Int.self, forKey: .waitingtime)
        cookingtime = try container.decode(Int.self, forKey: .cookingtime)
        nutritions = try container.decode(String.self, forKey: .nutritions)
        description = try container.decode(String.self, forKey: .description)
        recipesteps = try container.decode(String.self, forKey: .recipesteps)
        ingredients = try container.decode(String.self, forKey: .ingredients)
        dietary = try container.decode(String.self, forKey: .dietary)
        buttonimagepaths = try container.decode(String.self, forKey: .buttonimagepaths)

        if let array = try? container.decode([String].self, forKey: .category) {
            category = array
        } else if let single = try? container.decode(String.self, forKey: .category) {
            category = [single]
        } else {
            category = []
        }
    }
}
