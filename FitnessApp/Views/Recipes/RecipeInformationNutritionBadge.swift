
import Foundation
import SwiftUI
struct RecipeInformationNutritionBadge: View {
    var nutritionIndex : Int
    var nutritionValue: String
    
    enum NutritionType: Int {
        case cal = 0
        case carbs = 1
        case fat = 2
        case protein = 3
        
        var dictKey: String {
            switch self {
            case .cal:
                return "cal"
            case .carbs:
                return "carbs"
            case .fat:
                return "fat"
            case .protein:
                return "protein"
            }
        }
    }
    
    let nutritionBadgesIconsDict: [String: String] = [
        "cal": "flame",
        "carbs": "laurel.trailing",
        "fat": "drop",
        "protein": "carrot"
    ]

    var getBadgeImage : String{
        if let nutritionType = NutritionType(rawValue: nutritionIndex) {
            return nutritionBadgesIconsDict[nutritionType.dictKey] ?? ""
            
        }
        
        return ""
    }
    
    var body: some View {
        HStack(alignment: .top, spacing: 10) {
            Image(systemName: getBadgeImage)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 50, height: 50)
                //.clipShape(Circle())
                .padding(.leading, 25)
                .padding(.top, 10)

            Text(nutritionValue)
                .font(.body)
                .padding(.top, 25)

            Spacer() // This pushes the image and text to the left
        }
    }
}
