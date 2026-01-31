import SwiftUI
import AVKit

struct WorkoutView: View {

    @State private var workouts: [WorkoutVideosModel] = []

    // SEARCH
    @State private var searchText = ""
    @State private var debouncedText = ""
    @State private var debounceTask: Task<Void, Never>?

    // FILTERS
    @State private var selectedTypes: Set<String> = []
    @State private var selectedFocusAreas: Set<String> = []
    @State private var selectedDifficulties: Set<String> = []
    @State private var showFilter = false

    // VIDEO
    @State private var selectedWorkoutForPlay: WorkoutVideosModel? = nil

    // 🎀 farby ako Recipes
    private let bg = Color(red: 1.0, green: 0.97, blue: 0.99)
    private let accent = Color(red: 0.85, green: 0.20, blue: 0.70)
    private let accent2 = Color(red: 0.98, green: 0.67, blue: 0.83)

    private var filteredWorkouts: [WorkoutVideosModel] {
        workouts.filter { workout in
            let matchesSearch =
                debouncedText.isEmpty ||
                workout.name.localizedCaseInsensitiveContains(debouncedText)

            let matchesType =
                selectedTypes.isEmpty ||
                !Set(workout.typeTags).isDisjoint(with: selectedTypes)

            let matchesFocus =
                selectedFocusAreas.isEmpty ||
                selectedFocusAreas.contains(workout.focusAreaTag)

            let matchesDifficulty =
                selectedDifficulties.isEmpty ||
                selectedDifficulties.contains(workout.difficultyTag)

            return matchesSearch && matchesType && matchesFocus && matchesDifficulty
        }
    }

    var body: some View {
        ZStack {
            bg.ignoresSafeArea()

            ScrollView(showsIndicators: false) {
                VStack(spacing: 12) {

                    VStack(spacing: 6) {
                        Text("Workouts")
                            .font(.system(size: 26, weight: .bold))
                            .foregroundColor(.white)

                        Text("Find your next workout ✨")
                            .font(.system(size: 13, weight: .semibold))
                            .foregroundColor(.white.opacity(0.9))
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 18)
                    .background(
                        LinearGradient(
                            colors: [accent, accent2],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .clipShape(RoundedRectangle(cornerRadius: 26, style: .continuous))
                    .shadow(radius: 10, y: 4)
                    .padding(.horizontal, 14)
                    .padding(.top, -100)

                    // SEARCH
                    HStack(spacing: 10) {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.gray.opacity(0.9))

                        TextField("What would you like to find?", text: $searchText)
                            .autocapitalization(.none)
                            .font(.system(size: 16, weight: .medium))
                            .onChange(of: searchText) { value in
                                debounceTask?.cancel()
                                debounceTask = Task {
                                    try? await Task.sleep(nanoseconds: 250_000_000)
                                    if Task.isCancelled { return }
                                    await MainActor.run { debouncedText = value }
                                }
                            }

                        if !searchText.isEmpty {
                            Button {
                                searchText = ""
                                debouncedText = ""
                            } label: {
                                Image(systemName: "xmark.circle.fill")
                                    .foregroundColor(.gray.opacity(0.8))
                            }
                        }
                    }
                    .padding(.horizontal, 14)
                    .padding(.vertical, 12)
                    .background(Color.white.opacity(0.9))
                    .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                    .shadow(radius: 8, y: 3)
                    .padding(.horizontal, 14)

                    // FILTER BUTTON (ako Recipes)
                    Button {
                        showFilter = true
                    } label: {
                        Text("FILTER")
                            .font(.system(size: 15, weight: .bold))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 14)
                            .background(
                                LinearGradient(colors: [accent, accent2], startPoint: .leading, endPoint: .trailing)
                            )
                            .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
                            .shadow(radius: 8, y: 3)
                    }
                    .padding(.horizontal, 14)
                    .sheet(isPresented: $showFilter) {
                        FilterSelectionView(
                            selectedTypes: $selectedTypes,
                            selectedFocusAreas: $selectedFocusAreas,
                            selectedDifficulties: $selectedDifficulties,
                            isPresented: $showFilter
                        )
                    }

                    // LIST
                    LazyVStack(spacing: 14) {
                        ForEach(filteredWorkouts) { workout in
                            Button {
                                selectedWorkoutForPlay = workout
                            } label: {
                                WorkoutElement(workout: workout)
                            }
                            .buttonStyle(PlainButtonStyle())
                            .padding(.horizontal, 14)
                        }
                    }
                    .padding(.top, 6)
                    .padding(.bottom, 30)
                }
            }
        }
        .onAppear {
            // ✅ optional fix
            workouts = ContentLoader.loadJSON(
                fileName: "ContentData/Workout",
                type: [WorkoutVideosModel].self
            ) ?? []
        }
        .sheet(item: $selectedWorkoutForPlay) { workout in
            WorkoutVideoPlayerView(videoName: workout.videopath)
        }
    }
}

// MARK: - Video Player Sheet
struct WorkoutVideoPlayerView: View {
    let videoName: String
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()

            if let url = Bundle.main.url(forResource: videoName, withExtension: "mp4") {
                VideoPlayer(player: AVPlayer(url: url))
                    .ignoresSafeArea()
            } else {
                VStack(spacing: 12) {
                    Text("Video not found")
                        .foregroundColor(.white)
                        .font(.headline)
                    Text("Missing: \(videoName).mp4")
                        .foregroundColor(.white.opacity(0.7))
                        .font(.subheadline)
                }
            }

            VStack {
                HStack {
                    Spacer()
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark")
                            .foregroundColor(.black)
                            .padding(10)
                            .background(Color.white.opacity(0.9))
                            .clipShape(Circle())
                    }
                    .padding(.top, 20)
                    .padding(.trailing, 16)
                }
                Spacer()
            }
        }
    }
}
