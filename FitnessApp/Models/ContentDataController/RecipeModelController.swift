import Foundation
class RecipeModelController {
    var recipe: RecipesModel
    var recipeSteps : [String] = []
    var nutritions : [String] = []
    var ingredients: [String] = []
    var dietary: [String] = []
    var buttonImages: [String] = []

    init(recipe: RecipesModel) {
        self.recipe = recipe
  
        self.recipeSteps = splitStringIntoArray(inputString: recipe.recipesteps)
        self.nutritions = splitStringIntoArray(inputString: recipe.nutritions)
        self.ingredients = splitStringIntoArray(inputString: recipe.ingredients)
        self.dietary = splitStringIntoArray(inputString: recipe.dietary)
        self.buttonImages = splitStringIntoArray(inputString: recipe.buttonimagepaths)
    }

    func splitStringIntoArray(inputString: String) -> [String] {
        let arrayOfStrings = inputString.components(separatedBy: ";")
        return arrayOfStrings
    }
    
    var getFullDuration : Int {
        return self.recipe.waitingtime + self.recipe.cookingtime
    }
    
}
