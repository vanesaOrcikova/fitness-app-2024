import SwiftUI

struct Detail1: View {
    let imageNames = ["meat1", "meat2"]
    
    var body: some View {
        ScrollView {
            VStack {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                        ForEach(imageNames, id: \.self) { imageName in
                            Image(imageName)
                                .resizable()
                                .frame(maxWidth: 387)
                                .frame(height: 350)
                        }
                    }
                }
                .padding(.top, -100)
                
                Text("Meat")
                    .font(.system(size: 23))
                    .padding(.trailing, 315)
                    .padding(.top, 10)
                
                HStack {
                    ZStack {
                        RoundedRectangle(cornerRadius: 1)
                            .foregroundColor(.purple)
                            .frame(height: 30)
                            .frame(width: 75)
                        
                        Text("HEALTH")
                            .font(.system(size: 16))
                            .bold()
                            .foregroundColor(.white)
                            .font(.headline)
                    }
                    
                    ZStack {
                        RoundedRectangle(cornerRadius: 1)
                            .foregroundColor(.purple)
                            .frame(height: 30)
                            .frame(width: 60)
                        
                        Text("FOOD")
                            .font(.system(size: 16))
                            .bold()
                            .foregroundColor(.white)
                            .font(.headline)
                    }   
                }
                .padding(.trailing, 190)
                
                Text("--------------------------------------------")
                    .foregroundColor(.purple) // Farebná čiarka
                
                VStack {
                    Text("Meat can be taken from animals that are bred for slaughter, such as beef, pork, lamb, goat, chicken and turkey, or from wild hunted species such as deer and wild boar. In other countries or cultural areas, animals like bison, buffalo or reindeer are also consumed. Meat offers a high protein content (for example turkey has around 23g/ 100g), which is, just like the iron it contains, very high in bioavailability. That means it can be easily absorbed and processed in our body when eaten. Further, meat contains vitamins (A, B, D and others) and minerals like sodium, zinc and potassium. \n \n In recent years in particular, the consumption of meat is being discussed more and more and we should all be aware of the problems factory farming introduce. By now, scientists have also proved a direct link between meat consumption in industrial countries and climate change. This makes sense, as livestock farming produces more emissions than cars, ships and air travel together! Also the high demand for soy as a feed results in increased emissions of greenhouse gases. The clearing of rainforests to make space for grazing land or soy plantations is also a direct consequence.\n \n I don't exclusively follow a vegetarian or vegan diet. But I also don't reject styles of eating that don't incorporate animal products. I try to consciously live off plant-based foods for the most part, and am well aware of the consequences frequent meat consumption brings. \n \n If I decide to buy meat I only go for unprocessed and premium, organic quality. So I'd rather have a piece of pure chicken breast than a processed sausage or salami. Further, the animals should have enough free space in the fields, only be fed with organic food and not be pumped full of drugs. No doubt this meat does cost more but I think quality has its price, so you shouldn't be stingy here. Also, the high price may be a reason to perceive meat as a special treat again, like a 'Sunday roast', not as an everyday necessity. \n \n From my personal experience it takes a while until you feel like a meal is 'complete' without any meat or fish. Until a year ago, this was also still the case for me, but luckily it has changed since then. A meal consisting of only vegetables, grains and fruits can be 'complete' as well. But you have to allow this process for some time. With creativity and delicious recipes, you will not miss the daily consumption of meat - I promise.")
                        .padding(.horizontal, 20)
                        .padding(.top, 10)
                        .fixedSize(horizontal: false, vertical: true)
                    
//                    Text("I don't exclusively follow a vegetarian or vegan diet. But I also don't reject styles of eating that don't incorporate animal products. I try to consciously live off plant-based foods for the most part, and am well aware of the consequences frequent meat consumption brings. \n \n If I decide to buy meat I only go for unprocessed and premium, organic quality. So I'd rather have a piece of pure chicken breast than a processed sausage or salami. Further, the animals should have enough free space in the fields, only be fed with organic food and not be pumped full of drugs. No doubt this meat does cost more but I think quality has its price, so you shouldn't be stingy here. Also, the high price may be a reason to perceive meat as a special treat again, like a 'Sunday roast', not as an everyday necessity. \n \n From my personal experience it takes a while until you feel like a meal is 'complete' without any meat or fish. Until a year ago, this was also still the case for me, but luckily it has changed since then. A meal consisting of only vegetables, grains and fruits can be 'complete' as well. But you have to allow this process for some time. With creativity and delicious recipes, you will not miss the daily consumption of meat - I promise.")
//                        .padding(.horizontal, 20)
//                        .padding(.top, 10)
//                        .fixedSize(horizontal: false, vertical: true)
                }
            }
        }
        
    }
}


#Preview {
    Detail1()
}


