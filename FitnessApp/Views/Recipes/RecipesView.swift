import SwiftUI
import AVKit
import HalfASheet

struct RecipesView: View {
    @State private var contentDataRecipes: [RecipesModel]? = []
    
    @State private var searchText: String = ""
    @State private var isSearching = false
    
    @State private var selectedFilter: String = ""
    @State private var isFilterSelectionSheetPresented = false
    @State private var selectedNewestOption: String = ""
    @State private var isNewestSelectionSheetPresented = false
    
    var body: some View {
       // NavigationView {
            ScrollView {
                VStack {
                    Text("Recipes")
                        .font(.system(size: 24))
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .padding(.top, 20)
                        .frame(maxWidth: .infinity)
                        .frame(height: 100)
                        .background(Color.purple)
                        .padding(.top, -145)
                    
                    HStack(spacing: 35) {
                        TextField("What would you like to eat?", text: $searchText)
                            .font(.system(size: isSearching ? 17 : 19))
                            .autocapitalization(.none)
                            .padding(15)
                            .padding(.leading, 42)
                            .background(
                                ZStack(alignment: .leading) {
                                    Image(systemName: "magnifyingglass")
                                        .foregroundColor(.gray)
                                        .frame(width: 25, height: 25)
                                        .padding(.leading, 10)
                                    RoundedRectangle(cornerRadius: 1)
                                        .stroke(Color.gray, lineWidth: 1)
                                        .frame(height: 55)
                                        .frame(width: isSearching ? 310 : 370)
                                }
                            )
                        if isSearching {
                            Button(action: {
                                withAnimation {
                                    isSearching = false
                                    searchText = ""
                                }
                            }) {
                                Image(systemName: "xmark.circle.fill")
                                    .foregroundColor(.black)
                                    .frame(width: 30, height: 30)
                                    .padding(.leading, -25)
                                    .padding(.trailing, 20)
                            }
                        }
                    }
                    .padding(.top, -40)
                    .frame(maxWidth: .infinity)
                    .padding(.bottom, 5)
                    .onTapGesture {
                        withAnimation {
                            isSearching = true
                        }
                    }
                    
                    HStack {
                        RoundedRectangle(cornerRadius: 1)
                            .fill(Color(red: 200/255, green: 180/255, blue: 183/255))
                            .frame(maxWidth: 180)
                            .frame(height: 45)
                            .overlay(
                                Button(action: {
                                    isFilterSelectionSheetPresented.toggle()
                                }) {
                                    Image(systemName: "slider.horizontal.3")
                                        .resizable()
                                        .frame(width: 18, height: 18)
                                        .foregroundColor(.white)
                                    Text("FILTER")
                                        .font(.headline)
                                        .foregroundColor(.white)
                                }
                            )
                    
                        .sheet(isPresented: $isFilterSelectionSheetPresented) {
                            FilterSelectionView2(selectedFilter: $selectedFilter, isSheetPresented: $isFilterSelectionSheetPresented)
                        }
                        // NEWEST button
                        RoundedRectangle(cornerRadius: 1)
                            .fill(Color(red: 200/255, green: 180/255, blue: 183/255))
                            .frame(maxWidth: 180)
                            .frame(height: 45)
                            .overlay(
                                Button(action: {
                                    isNewestSelectionSheetPresented.toggle()
                                }) {
                                    Image(systemName: "laser.burst")
                                        .resizable()
                                        .frame(width: 18, height: 18)
                                        .foregroundColor(.white)
                                    Text("SORT BY")
                                        .font(.headline)
                                        .foregroundColor(.white)
                                }
                            )
                        .sheet(isPresented: $isNewestSelectionSheetPresented) {
                            NewestSelectionView(selectedFilter: $selectedNewestOption, isSheetPresented: $isNewestSelectionSheetPresented)
                        }
                    }
                }
                
                //NOTE: generate recipes grid based on how much recipes is defined
                let gridLayout = [GridItem(.fixed(180)), GridItem(.fixed(180))]
                if let recipes = self.contentDataRecipes, !recipes.isEmpty {
                    LazyVGrid(columns: gridLayout, spacing: 10) {
                        ForEach(0..<recipes.count, id: \.self) { index in
                            NavigationLink(destination: RecipeDescriptionView(recipeData: recipes[index])) {
                                RecipesViewScrollTemplateElement(recipeData: recipes[index])
                            }
                        }
                    }
                } else {
                    Text("ERROR: No recipes available.")
                }

            }
       // }
            .onAppear{
            self.contentDataRecipes = ContentLoader.loadJSON(fileName: "ContentData/Recipes", type: [RecipesModel].self)
        }
    }
}

struct FilterSelectionView2: View {
    @Binding var selectedFilter: String
    @Binding var isSheetPresented: Bool
    @State private var selectedFilters: Set<String> = []
    @Environment(\.presentationMode) var presentationMode
    
    let filterOptions = ["Snacks", "Desserts", "Dinner", "Lunch", "Breakfast", "Salads", "Soups", "Drinks", "Meal Prep"]

    var body: some View {
        VStack {
            HStack {
                Text("FILTER")
                    .font(.title)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding()
                    .offset(x: 25)
                
                //Spacer()
            
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Image(systemName: "xmark")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 18, height: 18) // Adjust the size as needed
                        .foregroundColor(.black)
                }
            }
            .padding(.horizontal)

            ScrollView {
                LazyVGrid(columns: [GridItem(.adaptive(minimum: 80))], spacing: 16) {
                    ForEach(filterOptions, id: \.self) { filter in
                        Button(action: {
                            if selectedFilters.contains(filter) {
                                selectedFilters.remove(filter)
                            } else {
                                selectedFilters.insert(filter)
                            }
                        }) {
                            Text(filter)
                                .font(.system(size: 17))
                                .foregroundColor(Color.black)
                                .frame(width: 85, height: 50)
                                .background(
                                    RoundedRectangle(cornerRadius: selectedFilters.contains(filter) ? 15 : 0)
                                        .fill(selectedFilters.contains(filter) ? Color(red: 245/255, green: 192/255, blue: 203/255)  : Color.gray.opacity(0.1))
                                )
                        }
                        .cornerRadius(15)
                    }
                }
                .padding()

                HStack (spacing: -10){
                    Button(action: {
                        // Apply filter logic goes here
                        selectedFilter = selectedFilters.sorted().joined(separator: ", ")
                        isSheetPresented = false
                    }) {
                        Text("Apply")
                            .font(.system(size: 20, weight: .bold))
                            .foregroundColor(.white)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.pink)
                            .cornerRadius(15)
                    }
                    .padding(.horizontal, 10)

                    Button(action: {
                        // Reset filter logic goes here
                        selectedFilters.removeAll()
                    }) {
                        Text("Reset")
                            .font(.system(size: 20, weight: .bold))
                            .foregroundColor(.white)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.pink)
                            .cornerRadius(15)
                    }
                    .padding(.horizontal, 10)
                }
                .padding(.top, 16)
            }
        }
        .onAppear {
            // Load previously selected filters when the sheet appears
            selectedFilters = Set(selectedFilter.components(separatedBy: ", "))
        }
    }
        
}

struct NewestSelectionView: View {
    @Binding var selectedFilter: String
    @Binding var isSheetPresented: Bool
    @State private var selectedNewestOption: String = ""
    @Environment(\.presentationMode) var presentationMode
    
    let newestOptions = ["Newest", "Quickest", "Easiest"]

    var body: some View {
        VStack {
            HStack {
                Text("SORT BY")
                    .font(.title)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding()
                    .offset(x: 25)
                
                //Spacer()
            
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Image(systemName: "xmark")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 18, height: 18) // Adjust the size as needed
                        .foregroundColor(.black)
                }
            }
            .padding(.horizontal)
            
            ForEach(newestOptions, id: \.self) { option in
                Button(action: {
                    selectedNewestOption = option
                    selectedFilter = option // Update the initial selection binding
                    withAnimation {
                        // Animate the change
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                            // Dismiss the sheet after 1 second (adjust as needed)
                            presentationMode.wrappedValue.dismiss()
                        }
                    }
                }) {
                    Text(option)
                        .font(.system(size: 17))
                        .foregroundColor(Color.black)
                        .frame(maxWidth: .infinity, minHeight: 50)
                        .background(
                            RoundedRectangle(cornerRadius: 15)
                                .fill(selectedFilter.contains(option) ? Color(red: 245/255, green: 192/255, blue: 203/255) : Color.gray.opacity(0.2))
                        )
                        .padding(.vertical, 5)
                }
                .cornerRadius(15)
                .padding(.horizontal, 10)
            }
            
            Spacer()
        }
        .padding(.bottom, 30)
    }
}


                        
  

#Preview {
    RecipesView()
}



