import SwiftUI

struct RecipesViewScrollTemplateElement: View {
    let recipeData: RecipesModel

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Image(recipeData.imgpath)
                .resizable()
                .scaledToFill()
                .frame(height: 150)
                .clipped()

            Text(recipeData.name)
                .font(.system(size: 14, weight: .bold))
                .padding(10)
                .lineLimit(2)
        }
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 18))
        .shadow(radius: 8)
    }
}
