import SwiftUI

struct Detail2: View {
    let imageName = "protein" // Nastavte název jednoho obrázku

    var body: some View {
        ScrollView {
            VStack {
                Image(imageName)
                    .resizable()
                    .frame(maxWidth: 390)
                    .frame(height: 350)
                    .padding(.top, -100)

                Text("Proteins - not only for muscle")
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
                    Text("A protein is a macronutrient and considered to be one of the most important nutrients, along with fat and carbohydrates. A distinction is made between animal- and plant-based proteins. Proteins are an important building substance in our bodies, you can find them in every cell and tissue. Further, they are, among other things, responsible for muscle growth, the immune system and the regulation of hormones. You should have a daily intake of about 0.8-1g of protein per kg of bodyweight. When doing intense physical activities, you can aim for more - around 1.8-2g per kg of bodyweight. Building muscles just by eating more protein or losing fat this way is (unfortunately) a myth - this can only happen in combination with physical activity.")
                        .padding(.horizontal, 20)
                        .padding(.top, 10)
                        .fixedSize(horizontal: false, vertical: true)
                    
                    Text("THE CONNECTION BETWEEN PROTEIN AND HUNGER")
                        .font(.system(size: 20))
                        .fontWeight(.bold)
                        .padding(.top, 20)
                        .fixedSize(horizontal: false, vertical: true)
                    
                    Text("Studies and experiments by scientists show that both animals and humans only eat until their protein requirement is covered. Carbohydrates and fats are not that important when it comes to being hungry. The problem with industrially made foods is that they are usually mixed with cheap sugars and fats. This automatically reduces their protein content, which means that the amount of protein is proportionally lower. That's why you re more likely to overeat and chronically stay hungry.")
                        .padding(.horizontal, 20)
                        //.padding(.top, 10)
                        .fixedSize(horizontal: false, vertical: true)
                    
                    Text("PROTEIN PRODUCTS I LIKE")
                        .font(.system(size: 20))
                        .fontWeight(.bold)
                        .padding(.top, 20)
                        .fixedSize(horizontal: false, vertical: true)
                    
                    Text("Generally speaking, we can assume you will cover your daily protein requirement with a balanced, healthy diet. If you don't consume enough protein, or just want to use protein shakes as an addition, protein supplements may be your solution. The best known are protein powders that can be used in smoothies or for baking. Powders made from animal sources such as milk protein (casein protein) or whey protein are the most common kinds. However, there are great vegan alternatives. My favourites are pea, rice, peanut, flaxseed and hemp protein, but you can also get protein powder made from soy, seeds and other nuts. \n\n There are also multi-component protein powders available that are a blend of different kinds and therefore offer the full amino acid spectrum. When buying protein powder, you should watch out for the ingredients and nutritional information. Usually the rule of thumb is: the fewer ingredients the better. Some manufacturers add sugar or sweeteners. That's not necessary at all, so I avoid these products. If I'd like to add sweetness to my shake, I can always use fresh fruit. I tend to get bloated from some protein powders. The same kind of another brand will work fine for me though. It's probably the level of processing, so be patient when finding a good one that works with your body! \n\n Another product category is protein bars. It's also crucial to have a look at the ingredients list here! They might sound healthy, but often contain added sugar, sweeteners, artificial flavours and various chemical ingredients. You should consider them sweets in this case.")
                        .padding(.horizontal, 20)
                        //.padding(.top, 10)
                        .fixedSize(horizontal: false, vertical: true)
                    
                    Text("**TIP:** Make sure you drink enough water when consuming protein shakes. People with medical conditions affecting the kidneys or their metabolism, as well as pregnant women, should only consume them to a limited extent, or not at all.")
                        .padding(.horizontal, 20)
                        .padding(.top, 10)
                        .fixedSize(horizontal: false, vertical: true)
                }
            }
        }

    }
}


#Preview {
    Detail2()
}
