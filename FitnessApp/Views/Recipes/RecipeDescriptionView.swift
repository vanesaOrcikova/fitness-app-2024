import SwiftUI

struct RecipeDescriptionView: View {
    @State private var isShowingImages = false
    
    @State private var selectedCategory: String = "Ingredients"
    @State private var number: Int = 1
    
    var recipeData: RecipesModel?
    private var contentDataRecipeController : RecipeModelController?

    init(recipeData : RecipesModel? = nil)
    {
        self.recipeData = recipeData
        if let recipe = recipeData {
               self.contentDataRecipeController = RecipeModelController(recipe: recipe)
        }
    }
    
    var body: some View {
        if let recipeController = contentDataRecipeController{
            ScrollView {
                VStack {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack {
                            Image(recipeController.recipe.imgpath)
                                .resizable()
                                .frame(maxWidth: 390)
                                .frame(height: 400)
                        }
                    }
                    .padding(.top, -185)
                    
//                    ScrollView(.horizontal, showsIndicators: false) {
//                        HStack(spacing: 0) {
//                            ForEach(0..<2) { _ in
//                                Image(recipeController.recipe.imgpath)
//                                    .resizable()
//                                    .frame(maxWidth: 390)
//                                    .frame(height: 370)
//                            }
//                        }
//                    }
//                    .padding(.top, -195)

                    
                    HStack {
                        Text(recipeController.recipe.name)
                            .font(.system(size: 23))
                        Spacer()
                    }
                    .padding(.top, 10)
                    .padding(.leading, 31)
                    
                    HStack {
                        ZStack {
                            RoundedRectangle(cornerRadius: 1)
                                .foregroundColor(.purple)
                                .frame(height: 30)
                                .frame(width: 75)
                            
                            Text("\(recipeController.getFullDuration) MIN")
                                .font(.system(size: 16))
                                .bold()
                                .foregroundColor(.white)
                                .font(.headline)
                        }
                        
                        
                        ZStack {
                            RoundedRectangle(cornerRadius: 1)
                                .foregroundColor(.purple)
                                .frame(height: 30)
                                .frame(width: 75)
                            
                            Text(recipeController.recipe.difficulty.uppercased(with: .autoupdatingCurrent))
                                .font(.system(size: 16))
                                .bold()
                                .foregroundColor(.white)
                                .font(.headline)
                        }     
                    }
                    .padding(.trailing, 170)
                    
                    Spacer()
                    
                   
                    VStack {
                        HStack {
                            Text("WAITING TIME")
                                .font(.system(size: 16))
                                .bold()
                                .foregroundColor(.brown)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(.leading, 30)
                            
                            Button(action: {
                                // Action for the divider
                                print("Divider Tapped")
                            }) {
                                Rectangle()
                                    .foregroundColor(.brown)
                                    .frame(height: 3)
                                    //.frame(width: min(CGFloat(recipeController.recipe.duration) * 3, 180))
                                    .frame(width: min(CGFloat(recipeController.recipe.waitingtime) * 3, 180))
                                //.offset(x: 10)
                                //.padding(.horizontal, 30)
                            }
                            
                            Text("\(recipeController.recipe.waitingtime) MIN")
                            //Text("\(recipeController.recipe.duration) MIN")
                                .foregroundColor(.black)
                                .font(.system(size: 14))
                                .padding(.trailing)
                        }
                        
                        HStack {
                            Text("COOKING TIME")
                                .font(.system(size: 16))
                                .bold()
                                .foregroundColor(.green)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(.leading, 30)
                            
                            Button(action: {
                                // Action for the divider
                                print("Divider Tapped")
                            }) {
                                Rectangle()
                                    .foregroundColor(.green)
                                    .frame(height: 3)
                                    .frame(width: min(CGFloat(recipeController.recipe.cookingtime) * 3, 180))
                                //.offset(x: 10)
                                //.padding(.horizontal, 30)
                            }
                            
                            Text("\(recipeController.recipe.cookingtime) MIN")
                                .foregroundColor(.black)
                                .font(.system(size: 14))
                                .padding(.trailing)
                        }}
                    
                    Text("--------------------------------------------")
                        .foregroundColor(.purple) // Farebná čiarka
                    
                    VStack {
                        Text(recipeController.recipe.description)
                            .padding(.horizontal, 20)
                            .padding(.top, -20)
                            .fixedSize(horizontal: false, vertical: true)
                            .padding(.bottom, 10)
                            .padding(.leading, -8)

                        Text("Information")
                            .font(.system(size: 23))
                            .padding(.trailing, 220)
                           //.padding(.top, -50)
                            .font(.headline)
                            
                        Picker("", selection: $selectedCategory) {
                            ForEach(GlobalData.recipeCategory, id: \.self) { header in
                                Text(header)
                                    .tag(header)
                            }
                        }
                        .pickerStyle(SegmentedPickerStyle())

                        if !selectedCategory.isEmpty {
//                            if selectedCategory == GlobalData.recipeCategory[0]{
//                                VStack(alignment: .leading){
//                                    ForEach(Array(recipeController.ingredients.enumerated()), id: \.element) { index, ingredient in
//                                        Text("• \(ingredient)")
//                                            // .padding(.horizontal, 20)
//                                            .padding(.trailing, 125)
//                                     }
//                                }
//                            }
                            if selectedCategory == GlobalData.recipeCategory[0] {
                                VStack(alignment: .leading) {
                                    ForEach(Array(recipeController.ingredients.enumerated()), id: \.element) { index, ingredient in
                                        HStack {
                                            Text("• \(ingredient)")
                                                .padding(.leading, 10)
                                            Spacer()
                                            
                                        }
                                    }
                                }
                                }
                                else if selectedCategory == GlobalData.recipeCategory[1]{
                                VStack(alignment: .leading, spacing: 4) {
                                    ForEach(Array(recipeController.nutritions.enumerated()), id: \.element) { index, nutrition in
                                        RecipeInformationNutritionBadge(nutritionIndex: index, nutritionValue: nutrition )
                                    }
                                 
                                    Text("per portion") // This text is below the HStack
                                        .font(.body)
                                        .padding(.top, 5)
                                        .padding(.leading, 22)
                                }
                    
                            } else {
                                VStack(alignment: .leading, spacing: 4) {
                                    ForEach(Array(recipeController.dietary.enumerated()), id: \.element) { index, dietaryTag in
                                        RecipeInformationDietaryInfo(dietaryTag: dietaryTag)
                                    }
                                }
                            }
                        }
                        
                        Text("------------------------------------------")
                            .foregroundColor(.purple) // Farebná čiarka
                        
                        Text("Steps")
                            .font(.system(size: 23))
                            .padding(.trailing, 280)
                           //.padding(.top, 10)
                            //.padding(.top, 4)
                            .font(.headline)
                        
                        VStack(alignment: .leading) {
                            ForEach(Array(recipeController.recipeSteps.enumerated()), id: \.element) { index, recipeStep in
                                HStack {
                                    Text("\(index + 1). \(recipeStep)")
                                        .padding(.leading, 14)
                                    Spacer()
                                    
                                }
                                
                            }
                        }.padding(.bottom, 10)
                        
                        Button(action: {
                            isShowingImages.toggle()
                        }) {
                            Text("More Images")
                                .font(.system(size: 17))
                                .bold()
                                .foregroundColor(.white)
                                .padding()
                                .background(Color.purple)
                                .cornerRadius(10)
                        }
                                    
                        if isShowingImages {
                            VStack {
                                VStack(alignment: .leading, spacing: 4) {
                                    ForEach(Array(recipeController.buttonImages.enumerated()), id: \.element) { index, buttonImage in
                                           Image(buttonImage)
                                                .resizable()
                                                .scaledToFit()
                                                .frame(maxWidth: 390, maxHeight: 370)
                                            }
                                        }
            
                                Button(action: {
                                    isShowingImages.toggle()
                                }) {
                                    Image(systemName: "xmark.circle.fill")
                                        .foregroundColor(.black)
                                        .padding()
                                }
                            }
                        }
                        
                        Spacer()
                    }
                    .padding()
                            
                    //}
                }
            }
        }
    }
}

#Preview {
    RecipeDescriptionView()
}
