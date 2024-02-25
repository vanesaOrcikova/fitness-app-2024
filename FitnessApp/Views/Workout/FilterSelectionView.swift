import SwiftUI

struct FilterSelectionView: View {
    @Binding var selectedFilter: String
    @Binding var isSheetPresented: Bool
    @State private var selectedFilters: Set<String> = []
    @Environment(\.presentationMode) var presentationMode
    
    let filterOptions = ["Hiit", "Warm up", "Dance", "Cardio", "Strength training", "Stretching"]
    let filterOptions2 = ["ABs", "Back", "Booty", "Arms", "Full body", "Legs", "Upper body", "Core"]
    let filterOptions3 = ["Easy", "Medium", "Advanced"]

    var body: some View {
        VStack {
            HStack {
                Text("FILTER")
                    .font(.title)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding()
                    .offset(x: 25)

                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Image(systemName: "xmark")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 18, height: 18)
                        .foregroundColor(.black)
                }
            }
            .padding(.horizontal)

            HStack {
                Text("Type")
                    .font(.system(size: 18))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.leading, 25) // Align to the left
                    .padding(.bottom, -15)
            }

            ScrollView {
                LazyVGrid(columns: [GridItem(.adaptive(minimum: 80))], spacing: 15) {
                    ForEach(filterOptions, id: \.self) { filter in
                        Button(action: {
                            if selectedFilters.contains(filter) {
                                selectedFilters.remove(filter)
                            } else {
                                selectedFilters.insert(filter)
                            }
                        }) {
                            Text(filter)
                                .font(.system(size: 18))
                                .foregroundColor(Color.black)
                                .frame(width: 86, height: 50)
                                .background(
                                    RoundedRectangle(cornerRadius: selectedFilters.contains(filter) ? 15 : 0)
                                        .fill(selectedFilters.contains(filter) ? Color(red: 210/255, green: 180/255, blue: 180/255)  : Color.gray.opacity(0.2))
                                )
                        }
                        .cornerRadius(15)
                    }
                }
                .padding()
                
                HStack {
                    Text("Focus Area")
                        .font(.system(size: 18))
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.leading, 25) // Align to the left
                        .padding(.bottom, -12)
                }

                ScrollView {
                    LazyVGrid(columns: [GridItem(.adaptive(minimum: 80))], spacing: 15) {
                        ForEach(filterOptions2, id: \.self) { filter in
                            Button(action: {
                                if selectedFilters.contains(filter) {
                                    selectedFilters.remove(filter)
                                } else {
                                    selectedFilters.insert(filter)
                                }
                            }) {
                                Text(filter)
                                    .font(.system(size: 18))
                                    .foregroundColor(Color.black)
                                    .frame(width: 85, height: 50)
                                    .background(
                                        RoundedRectangle(cornerRadius: selectedFilters.contains(filter) ? 15 : 0)
                                            .fill(selectedFilters.contains(filter) ? Color(red: 245/255, green: 192/255, blue: 203/255)  : Color.gray.opacity(0.2))
                                    )
                            }
                            .cornerRadius(15)
                        }
                    }}
                    .padding()
                
                HStack {
                    Text("Difficulty")
                        .font(.system(size: 18))
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.leading, 25) // Align to the left
                        .padding(.bottom, -12)
                }

                ScrollView {
                    LazyVGrid(columns: [GridItem(.adaptive(minimum: 80))], spacing: 15) {
                        ForEach(filterOptions3, id: \.self) { filter in
                            Button(action: {
                                if selectedFilters.contains(filter) {
                                    selectedFilters.remove(filter)
                                } else {
                                    selectedFilters.insert(filter)
                                }
                            }) {
                                Text(filter)
                                    .font(.system(size: 18))
                                    .foregroundColor(Color.black)
                                    .frame(width: 85, height: 50)
                                    .background(
                                        RoundedRectangle(cornerRadius: selectedFilters.contains(filter) ? 15 : 0)
                                            .fill(selectedFilters.contains(filter) ? Color(red: 245/255, green: 192/255, blue: 203/255)  : Color.gray.opacity(0.2))
                                    )
                            }
                            .cornerRadius(15)
                        }
                    }}
                    .padding()
                
                

                HStack(spacing: -10) {
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
