import Foundation
import SwiftUI
struct RandomExerciseChallengeView : View {
    @State private var contentDataRandomChallenge: [HomeRandomChallengeModel]? = []
    @State private var contentDataRandomExercise: [HomeRandomExerciseModel]? = []
    
    @State private var showAlert = false
    @State private var randomChallenge = ""
    @State private var selectedCategory: String = ""
    @State private var selectedCategoryExercises: [HomeRandomExerciseModel] = []
    @State private var selectedCategoryExerciseIndex: Int = 0
    
    @State private var isImage1Enlarged = false
    @State private var isImage2Enlarged = false
    
    var body : some View{
        VStack(alignment: .leading, spacing: 14) {
            Text("Exercise ideas and random challenge:")
                .font(.headline)
                .padding(.bottom, 8)
                .padding(.leading, 4)
        
            Picker("", selection: $selectedCategory) {
                ForEach(GlobalData.exerciseCategory, id: \.self) { header in
                     Text(header)
                         .tag(header)
                 }
             }
             .pickerStyle(SegmentedPickerStyle())
             .onChange(of: selectedCategory) { newValue in
                 selectedCategoryExercises = self.contentDataRandomExercise?.filter { $0.category == newValue.lowercased() } ?? []
                 selectedCategoryExerciseIndex =  Utilities.generateRandomIndex(excluding: selectedCategoryExerciseIndex, in: 0..<selectedCategoryExercises.count)
             }
            
            if !selectedCategory.isEmpty {
                if !selectedCategoryExercises.isEmpty {
                    VStack {
                        HStack {
                            Text("• \(selectedCategoryExercises[selectedCategoryExerciseIndex].exercise1)")
                                .padding(.leading, 8)
                            Image(selectedCategoryExercises[selectedCategoryExerciseIndex].exercise1imgpath)
                                .resizable()
                                .scaledToFit()
                                //.frame(width: 50, height: 50) // Set your desired image size here
                                .frame(width: isImage1Enlarged ? 200 : 50, height: isImage1Enlarged ? 200 : 50) // Set your desired image size here
                                .onTapGesture {
                                    isImage1Enlarged.toggle()
                                }
                                .gesture(
                                    isImage1Enlarged ?
                                        AnyGesture(
                                            TapGesture()
                                                .onEnded { _ in
                                                    // Handle closing the enlarged image, e.g., by setting isImageEnlarged to false
                                                    isImage1Enlarged = false
                                                }
                                        ) : nil
                                )
                        }

                        HStack {
                            Text("• \(selectedCategoryExercises[selectedCategoryExerciseIndex].exercise2)")
                                .padding(.leading, 8)
                            Image(selectedCategoryExercises[selectedCategoryExerciseIndex].exercise2imgpath)
                                .resizable()
                                .scaledToFit()
                               // .frame(width: 50, height: 50) // Set your desired image size here
                                .frame(width: isImage2Enlarged ? 200 : 50, height: isImage2Enlarged ? 200 : 50) // Set your desired image size here
                                .onTapGesture {
                                    isImage2Enlarged.toggle()
                                }
                                .gesture(
                                    isImage2Enlarged ?
                                        AnyGesture(
                                            TapGesture()
                                                .onEnded { _ in
                                                    // Handle closing the enlarged image, e.g., by setting isImageEnlarged to false
                                                    isImage2Enlarged = false
                                                }
                                        ) : nil
                                )
                        }
                    }
                }

                
                Button(action: {
                    selectedCategoryExerciseIndex =  Utilities.generateRandomIndex(excluding: selectedCategoryExerciseIndex, in: 0..<selectedCategoryExercises.count) //Tento kód vykoná náhodný výber indexu prvku v kolekcii vybranej kategórie cvičení a uloží tento nový index do premennej selectedCategoryExerciseIndex. Týmto spôsobom sa dosiahne efekt zamiešania (shuffle) výberu cvičenia v danej kategórii. Funkcia Utilities.generateRandomIndex(excluding:in:) generuje náhodný index s vylúčením aktuálneho indexu selectedCategoryExerciseIndex a pracuje s rozsahom indexov od 0 do selectedCategoryExercises.count - 1, kde selectedCategoryExercises je kolekcia cvičenia v danej kategórii.
                }) {
                    Text("Shuffle")
                        .padding()
                        .foregroundColor(.white)
                        .background(Color.red)
                        .cornerRadius(8)
                        .frame(maxWidth: .infinity, alignment: .center)
                }
            }

            Button(action: {
                randomChallenge = self.contentDataRandomChallenge?.randomElement()?.challenge ?? "Error: Not avalaible challenge"
                showAlert = true
            }) {
                Text("Random challenge or task")
                    .padding()
                    .foregroundColor(.white)
                    .background(Color.purple)
                    .cornerRadius(8)
                    .frame(maxWidth: .infinity, alignment: .center)
            }
            
        }
        .padding()
        .background(Color.gray.opacity(0.1))
        .cornerRadius(8)
        .onAppear{
            self.contentDataRandomChallenge = ContentLoader.loadJSON(fileName: "ContentData/HomeRandomChallenge", type: [HomeRandomChallengeModel].self)
            self.contentDataRandomExercise = ContentLoader.loadJSON(fileName: "ContentData/HomeRandomExercise", type: [HomeRandomExerciseModel].self)
        }.alert(isPresented: $showAlert) {
            Alert(
                title: Text("Random challenge or task"),
                message: Text(randomChallenge),
                dismissButton: .default(Text("OK"))
            )
        }
        .offset(y: 10)
    }
}
