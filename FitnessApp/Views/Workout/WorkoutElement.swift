//import SwiftUI
//
//struct WorkoutElement: View {
//    
//    var contentDataVideos: WorkoutVideosModel?
//    
//    var body: some View {
//        ZStack {
//            Image(contentDataVideos?.videopath ?? "")
//                .resizable()
//                .frame(width: 178)
//                .frame(height: 215)
//
//            RoundedRectangle(cornerRadius: 1)
//                .fill(Color.white.opacity(0.7))
//                .frame(maxWidth: 180)
//                .frame(height: 75)
//                .padding(.top, 180)
//            Text(contentDataVideos?.name ?? "Error: Missing Data")
//                .foregroundColor(.black)
//                .font(.headline)
//                .padding(.top, 160)
//            //Spacer()
//        }
//        .offset(y: -16)
//        .padding(.bottom, -38)
//        
//    }
//}

import SwiftUI
import AVKit

//struct WorkoutElement: View {
//    var contentDataVideos: WorkoutVideosModel?
//
//    var body: some View {
//        VStack {
//            if let videoURL = contentDataVideos?.videopath,
//                let url = URL(string: videoURL) {
//                VideoPlayer(player: AVPlayer(url: url))
//                    .frame(width: 370, height: 209)
//                    .padding(.bottom, 8)
//            } else {
//                Text("Error: Missing Video")
//            }
//
//            RoundedRectangle(cornerRadius: 0)
//                .fill(Color.purple.opacity(0.2))
//                .frame(maxWidth: 370)
//                .frame(height: 70)
//                .padding(.top, -8)
//
//            Text(contentDataVideos?.name ?? "Error: Missing Data")
//                .foregroundColor(.black)
//                .font(.headline)
//                .padding(.top, -50)
//        }
//    }
//}

struct VideoPlayerElement: View {
    let videoURL: URL
    let description: String
    
    var body: some View {
        VStack {
            VideoPlayer(player: AVPlayer(url: videoURL))
                .frame(width: 370, height: 209)
            
            RoundedRectangle(cornerRadius: 0)
                .fill(Color.purple.opacity(0.2))
                .frame(maxWidth: 370)
                .frame(height: 70)
                .padding(.top, -8)
            
            Text(description)
                .foregroundColor(.black)
                .font(.headline)
                .padding(.top, -50)
        }
    }
}
