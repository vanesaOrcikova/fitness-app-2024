
import Foundation
import SwiftUI
struct RecipeInformationDietaryInfo: View {
    var dietaryTag: String

    var getBadgeImage : String{
        return "dietary_\(dietaryTag)"
    }
    
    var getBadgeText : String{
        return dietaryInfoTextDict[dietaryTag] ?? ""
    }
    
    let dietaryInfoTextDict: [String: String] = [
        "gluten_free": "Gluten Free",
        "lactose_free": "Lactose Free",
        "nut_no": "Nuts Free",
        "sugar_free": "Sugar Free",
        "vegan" : "Vegan",
        "vegetarian" : "Vegetarian"
    ]
    
    var body: some View {
        HStack(alignment: .top, spacing: 10) {
            Image(getBadgeImage)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 50, height: 50)
                //.clipShape(Circle())
                    .padding(.leading, 25)
                    .padding(.top, 10)
                
            Text(getBadgeText)
                .font(.body)
                .padding(.top, 25)

            Spacer() // This pushes the image and text to the left
        }
    }
}
