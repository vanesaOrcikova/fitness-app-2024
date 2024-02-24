import SwiftUI
import AVKit
import AVFoundation

struct VideoPlayerView: UIViewControllerRepresentable {
    let player: AVPlayer?

    func makeUIViewController(context: Context) -> AVPlayerViewController {
        let controller = AVPlayerViewController()
        controller.player = player
        controller.showsPlaybackControls = false
        return controller
    }

    func updateUIViewController(_ uiViewController: AVPlayerViewController, context: Context) {
        // Implement any updates here if needed
    }
}

struct WorkoutView: View {
    @State private var contentDataVideos: [WorkoutVideosModel]? = []
    
    @State private var searchText: String = ""
    @State private var isSearching = false
    @State private var showCancelButton = false
//    @State private var videoPlayer1: AVPlayer?
    @State private var videoPlayer1 = AVPlayer()
    @State private var videoPlayer2 = AVPlayer()
    @State private var videoPlayer3 = AVPlayer()
    @State private var videoPlayer4 = AVPlayer()
    @State private var videoPlayer5 = AVPlayer()
    
    @State private var selectedFilter: String = ""
    @State private var isFilterSelectionSheetPresented = false
    @State private var selectedNewestOption: String = ""
    @State private var isNewestSelectionSheetPresented = false
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack {
                    Text("Workouts")
                        .font(.system(size: 24))
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .padding(.top, 20)
                        .frame(maxWidth: .infinity)
                        .frame(height: 100)
                        .background(Color.purple)
                        .padding(.top, -145)
                    
                    HStack {
                        TextField("What would you like to find?", text: $searchText)
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
                                        .frame(width: isSearching ? 315 : 370)
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
                                    .padding(.leading, -5)
                                    .padding(.trailing, 20)
                            }
                        }
                    }
                    .padding(.top, -40)
                    .frame(maxWidth: .infinity)
                    .padding(.bottom, 10)
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
                            FilterSelectionView(selectedFilter: $selectedFilter, isSheetPresented: $isFilterSelectionSheetPresented)
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
                            NewestSelectionView2(selectedFilter: $selectedNewestOption, isSheetPresented: $isNewestSelectionSheetPresented)
                        }
                    }
                }
                    
//                    VideoPlayer(player: videoPlayer1)
//                        .frame(width: 370, height: 209)
//                        .onAppear {
//                            if let url = Bundle.main.url(forResource: "v1", withExtension: "mp4") {
//                                videoPlayer1 = AVPlayer(url: url)
//                                videoPlayer1?.play()
//                            } else {
//                                print("Nepodarilo sa nájsť súbor v1.mp4 v bundle.")
//                            }
//                        }
                
                    VideoPlayer(player: videoPlayer1)
                        .frame(width: 370, height: 209)
                        .onAppear {
                            if let url = Bundle.main.url(forResource: "video_full_body_stretch", withExtension: "mp4") {
                                videoPlayer1.replaceCurrentItem(with: AVPlayerItem(url: url))
                            } else {
                                print("Nepodarilo sa nájsť súbor v1.mp4 v bundle.")
                            }
                        }
                    
                    RoundedRectangle(cornerRadius: 0)
                        .fill(Color.purple.opacity(0.2))
                        .frame(maxWidth: 370)
                        .frame(height: 70)
                        .padding(.top, -8)
                    
                    Text("10 MIN Full Body Stretch")
                        .foregroundColor(.black)
                        .font(.headline)
                        .padding(.top, -50)
                
                VideoPlayer(player: videoPlayer2)
                    .frame(width: 370, height: 209)
                    .onAppear {
                        if let url = Bundle.main.url(forResource: "video_begginer_leg", withExtension: "mp4") {
                            videoPlayer2.replaceCurrentItem(with: AVPlayerItem(url: url))
                        } else {
                            print("Nepodarilo sa nájsť súbor v2.mp4 v bundle.")
                        }
                    }
                    
                    RoundedRectangle(cornerRadius: 0)
                        .fill(Color.purple.opacity(0.2))
                        .frame(maxWidth: 370)
                        .frame(height: 70)
                        .padding(.top, -8) // Adjust the top padding to control the space between the video and the rounded rectangle
                    
                    Text("10 MIN Beginner Ab Workout")
                        .foregroundColor(.black)
                        .font(.headline)
                        .padding(.top, -50)
                
                VideoPlayer(player: videoPlayer3)
                    .frame(width: 370, height: 209)
                    .onAppear {
                        if let url = Bundle.main.url(forResource: "video_beginner_abs", withExtension: "mp4") {
                            videoPlayer3.replaceCurrentItem(with: AVPlayerItem(url: url))
                        } else {
                            print("Nepodarilo sa nájsť súbor v3.mp4 v bundle.")
                        }
                    }
                
                RoundedRectangle(cornerRadius: 0)
                    .fill(Color.purple.opacity(0.2))
                    .frame(maxWidth: 370)
                    .frame(height: 70)
                    .padding(.top, -8)
                
                Text("10 MIN Full Body Workout")
                    .foregroundColor(.black)
                    .font(.headline)
                    .padding(.top, -50)
                
                VideoPlayer(player: videoPlayer4)
                    .frame(width: 370, height: 209)
                    .onAppear {
                        if let url = Bundle.main.url(forResource: "video_full_body_workout", withExtension: "mp4") {
                            videoPlayer4.replaceCurrentItem(with: AVPlayerItem(url: url))
                        } else {
                            print("Nepodarilo sa nájsť súbor v3.mp4 v bundle.")
                        }
                    }
                
                RoundedRectangle(cornerRadius: 0)
                    .fill(Color.purple.opacity(0.2))
                    .frame(maxWidth: 370)
                    .frame(height: 70)
                    .padding(.top, -8)
                
                Text("Dance Like Nobody's Watching")
                    .foregroundColor(.black)
                    .font(.headline)
                    .padding(.top, -50)
                
                VideoPlayer(player: videoPlayer5)
                    .frame(width: 370, height: 209)
                    .onAppear {
                        if let url = Bundle.main.url(forResource: "video_dance", withExtension: "mp4") {
                            videoPlayer5.replaceCurrentItem(with: AVPlayerItem(url: url))
                        } else {
                            print("Nepodarilo sa nájsť súbor v3.mp4 v bundle.")
                        }
                    }
                
                RoundedRectangle(cornerRadius: 0)
                    .fill(Color.purple.opacity(0.2))
                    .frame(maxWidth: 370)
                    .frame(height: 70)
                    .padding(.top, -8)
                
                Text("10 MIN Begginer Leg Workout")
                    .foregroundColor(.black)
                    .font(.headline)
                    .padding(.top, -50)
                
                    
                    Spacer()
                }
            }
            .onAppear{
                self.contentDataVideos = ContentLoader.loadJSON(fileName: "ContentData/Workout", type: [WorkoutVideosModel].self)
            }
        }
    }


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


struct NewestSelectionView2: View {
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
    WorkoutView()
}



