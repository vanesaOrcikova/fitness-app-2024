//import SwiftUI
//
//struct WorkoutElement: View {
//
//    let workout: WorkoutVideosModel
//
//    private let accent = Color(red: 0.85, green: 0.20, blue: 0.70)
//    private let accent2 = Color(red: 0.98, green: 0.67, blue: 0.83)
//
//    var body: some View {
//        ZStack(alignment: .bottomLeading) {
//
//            // Preview image: ak máš obrázok s rovnakým názvom ako videopath, zobrazí sa
//            // Inak sa zobrazí gradient
//            if UIImage(named: workout.videopath) != nil {
//                Image(workout.videopath)
//                    .resizable()
//                    .scaledToFill()
//            } else {
//                LinearGradient(colors: [accent.opacity(0.35), accent2.opacity(0.35)], startPoint: .topLeading, endPoint: .bottomTrailing)
//            }
//
//            VStack(alignment: .leading, spacing: 6) {
//                Text(workout.name)
//                    .font(.headline)
//                    .foregroundColor(.white)
//                    .shadow(radius: 4)
//
//                Text(workout.difficultyTag.uppercased())
//                    .font(.caption)
//                    .fontWeight(.bold)
//                    .foregroundColor(.white.opacity(0.95))
//                    .padding(.horizontal, 10)
//                    .padding(.vertical, 5)
//                    .background(Color.black.opacity(0.35))
//                    .cornerRadius(12)
//            }
//            .padding(12)
//        }
//        .frame(height: 200)
//        .clipped()
//        .cornerRadius(22)
//        .shadow(radius: 8, y: 4)
//    }
//}

//import SwiftUI
//import AVFoundation
//
//struct WorkoutElement: View {
//
//    let workout: WorkoutVideosModel
//
//    private let accent = Color(red: 0.85, green: 0.20, blue: 0.70)
//    private let accent2 = Color(red: 0.98, green: 0.67, blue: 0.83)
//
//    @State private var thumbnail: UIImage? = nil
//
//    var body: some View {
//        ZStack(alignment: .bottomLeading) {
//
//            // ✅ Thumbnail z videa
//            if let img = thumbnail {
//                Image(uiImage: img)
//                    .resizable()
//                    .scaledToFill()
//            } else {
//                // fallback kým sa načíta
//                LinearGradient(
//                    colors: [accent.opacity(0.35), accent2.opacity(0.35)],
//                    startPoint: .topLeading,
//                    endPoint: .bottomTrailing
//                )
//            }
//
//            // overlay aby text bol čitateľný
//            LinearGradient(
//                colors: [.black.opacity(0.0), .black.opacity(0.55)],
//                startPoint: .center,
//                endPoint: .bottom
//            )
//
//            // play ikonka
//            VStack {
//                Spacer()
//                HStack {
//                    Spacer()
//                    Image(systemName: "play.circle.fill")
//                        .font(.system(size: 46, weight: .bold))
//                        .foregroundColor(.white.opacity(0.95))
//                        .shadow(radius: 8)
//                    Spacer()
//                }
//                Spacer()
//            }
//
//            // texty
//            VStack(alignment: .leading, spacing: 6) {
//                Text(workout.name)
//                    .font(.headline)
//                    .foregroundColor(.white)
//                    .shadow(radius: 4)
//
//                Text(workout.difficultyTag.uppercased())
//                    .font(.caption)
//                    .fontWeight(.bold)
//                    .foregroundColor(.white)
//                    .padding(.horizontal, 10)
//                    .padding(.vertical, 5)
//                    .background(Color.black.opacity(0.35))
//                    .cornerRadius(12)
//            }
//            .padding(12)
//        }
//        .frame(height: 210)
//        .clipped()
//        .cornerRadius(22)
//        .shadow(radius: 8, y: 4)
//        .onAppear {
//            loadThumbnailIfNeeded()
//        }
//    }
//
//    private func loadThumbnailIfNeeded() {
//        // cache: nech sa to nerobí stále dookola pri scrollovaní
//        if let cached = ThumbnailCache.shared.get(key: workout.videopath) {
//            thumbnail = cached
//            return
//        }
//
//        guard let url = Bundle.main.url(forResource: workout.videopath, withExtension: "mp4") else {
//            return
//        }
//
//        DispatchQueue.global(qos: .userInitiated).async {
//            let asset = AVAsset(url: url)
//            let generator = AVAssetImageGenerator(asset: asset)
//            generator.appliesPreferredTrackTransform = true
//
//            // frame približne v 0.5s (lepší ako úplne prvý frame)
//            let time = CMTime(seconds: 0.5, preferredTimescale: 600)
//
//            do {
//                let cgImage = try generator.copyCGImage(at: time, actualTime: nil)
//                let uiImage = UIImage(cgImage: cgImage)
//
//                ThumbnailCache.shared.set(key: workout.videopath, image: uiImage)
//
//                DispatchQueue.main.async {
//                    thumbnail = uiImage
//                }
//            } catch {
//                // ak zlyhá, ostane gradient
//            }
//        }
//    }
//}
//
//// MARK: - Simple cache
//final class ThumbnailCache {
//    static let shared = ThumbnailCache()
//    private let cache = NSCache<NSString, UIImage>()
//
//    func get(key: String) -> UIImage? {
//        cache.object(forKey: key as NSString)
//    }
//
//    func set(key: String, image: UIImage) {
//        cache.setObject(image, forKey: key as NSString)
//    }
//}

import SwiftUI
import AVFoundation

struct WorkoutElement: View {

    let workout: WorkoutVideosModel

    private let accent = Color(red: 0.85, green: 0.20, blue: 0.70)
    private let accent2 = Color(red: 0.98, green: 0.67, blue: 0.83)

    @State private var thumbnail: UIImage? = nil

    var body: some View {
        ZStack(alignment: .bottomLeading) {

            // ✅ Thumbnail z videa
            if let img = thumbnail {
                Image(uiImage: img)
                    .resizable()
                    .scaledToFill()
            } else {
                // fallback kým sa načíta
                LinearGradient(
                    colors: [accent.opacity(0.35), accent2.opacity(0.35)],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            }

            // overlay aby text bol čitateľný
            LinearGradient(
                colors: [.black.opacity(0.0), .black.opacity(0.55)],
                startPoint: .center,
                endPoint: .bottom
            )

            // play ikonka
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    Image(systemName: "play.circle.fill")
                        .font(.system(size: 46, weight: .bold))
                        .foregroundColor(.white.opacity(0.95))
                        .shadow(radius: 8)
                    Spacer()
                }
                Spacer()
            }

            // texty
            VStack(alignment: .leading, spacing: 6) {
                Text(workout.name)
                    .font(.headline)
                    .foregroundColor(.white)
                    .shadow(radius: 4)

                Text(workout.difficultyTag.uppercased())
                    .font(.caption)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 5)
                    .background(Color.black.opacity(0.35))
                    .cornerRadius(12)
            }
            .padding(12)
        }
        .frame(height: 210)
        .clipped()
        .cornerRadius(22)
        .shadow(radius: 8, y: 4)
        .onAppear {
            loadThumbnailIfNeeded()
        }
    }

    private func loadThumbnailIfNeeded() {
        // cache: nech sa to nerobí stále dookola pri scrollovaní
        if let cached = ThumbnailCache.shared.get(key: workout.videopath) {
            thumbnail = cached
            return
        }

        guard let url = Bundle.main.url(forResource: workout.videopath, withExtension: "mp4") else {
            return
        }

        DispatchQueue.global(qos: .userInitiated).async {
            let asset = AVAsset(url: url)
            let generator = AVAssetImageGenerator(asset: asset)
            generator.appliesPreferredTrackTransform = true

            // frame približne v 0.5s (lepší ako úplne prvý frame)
            let time = CMTime(seconds: 0.5, preferredTimescale: 600)

            do {
                let cgImage = try generator.copyCGImage(at: time, actualTime: nil)
                let uiImage = UIImage(cgImage: cgImage)

                ThumbnailCache.shared.set(key: workout.videopath, image: uiImage)

                DispatchQueue.main.async {
                    thumbnail = uiImage
                }
            } catch {
                // ak zlyhá, ostane gradient
            }
        }
    }
}

// MARK: - Simple cache
final class ThumbnailCache {
    static let shared = ThumbnailCache()
    private let cache = NSCache<NSString, UIImage>()

    func get(key: String) -> UIImage? {
        cache.object(forKey: key as NSString)
    }

    func set(key: String, image: UIImage) {
        cache.setObject(image, forKey: key as NSString)
    }
}
