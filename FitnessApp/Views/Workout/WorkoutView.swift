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
                            .frame(maxWidth: 370)
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
                    
                    
                    VideoPlayerElement(videoURL: Bundle.main.url(forResource: "video_full_body_stretch", withExtension: "mp4") ?? URL(string: "")!, description: "10 MIN Full Body Stretch")
                    
                    VideoPlayerElement(videoURL: Bundle.main.url(forResource: "video_begginer_leg", withExtension: "mp4") ?? URL(string: "")!, description: "10 MIN Beginner Ab Workout")
                    
                    VideoPlayerElement(videoURL: Bundle.main.url(forResource: "video_beginner_abs", withExtension: "mp4") ?? URL(string: "")!, description: "10 MIN Full Body Workout")
                    
                    VideoPlayerElement(videoURL: Bundle.main.url(forResource: "video_full_body_workout", withExtension: "mp4") ?? URL(string: "")!, description: "Dance Like Nobody's Watching")
                    
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
}

#Preview {
    WorkoutView()
}



