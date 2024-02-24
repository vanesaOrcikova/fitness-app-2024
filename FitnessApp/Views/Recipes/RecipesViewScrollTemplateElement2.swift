import SwiftUI

struct RecipesViewScrollTemplateElement2: View {
    
    var recipeData: RecipesModel?
    
    var body: some View {
        ZStack {
            Image(recipeData?.imgpath ?? "")
                .resizable()
                .frame(width: 178)
                .frame(height: 215)

            RoundedRectangle(cornerRadius: 1)
                .fill(Color.white.opacity(0.7))
                .frame(maxWidth: 180)
                .frame(height: 75)
                .padding(.top, 180)
            Text(recipeData?.name ?? "Error: Missing Data")
                .foregroundColor(.black)
                .font(.headline)
                .padding(.top, 160)
            //Spacer()
        }
        .offset(y: -16)
        .padding(.bottom, -38)
        
    }
}
