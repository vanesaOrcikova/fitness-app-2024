import Foundation
import SwiftUI

struct RandomExerciseChallengeView: View {

    @State private var contentDataRandomChallenge: [HomeRandomChallengeModel]? = []
    @State private var contentDataRandomExercise: [HomeRandomExerciseModel]? = []

    @State private var showAlert = false
    @State private var randomChallenge = ""
    @State private var selectedCategory: String = ""
    @State private var selectedCategoryExercises: [HomeRandomExerciseModel] = []
    @State private var selectedCategoryExerciseIndex: Int = 0

    @State private var isImage1Enlarged = false
    @State private var isImage2Enlarged = false

    private let accent = Color(red: 0.85, green: 0.20, blue: 0.70)
    private let accent2 = Color(red: 0.98, green: 0.67, blue: 0.83)

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {

            Text("Exercise ideas & random challenge")
                .font(.system(size: 18, weight: .bold))
                .foregroundColor(.black.opacity(0.85))

            Picker("", selection: $selectedCategory) {
                ForEach(GlobalData.exerciseCategory, id: \.self) { header in
                    Text(header).tag(header)
                }
            }
            .pickerStyle(.segmented)
            .onChange(of: selectedCategory) { newValue in
                selectedCategoryExercises = contentDataRandomExercise?.filter { $0.category == newValue.lowercased() } ?? []
                if !selectedCategoryExercises.isEmpty {
                    selectedCategoryExerciseIndex = Utilities.generateRandomIndex(excluding: selectedCategoryExerciseIndex, in: 0..<selectedCategoryExercises.count)
                }
            }

            if !selectedCategory.isEmpty, !selectedCategoryExercises.isEmpty {
                VStack(spacing: 10) {

                    ExerciseRow(
                        text: selectedCategoryExercises[selectedCategoryExerciseIndex].exercise1,
                        imageName: selectedCategoryExercises[selectedCategoryExerciseIndex].exercise1imgpath,
                        isEnlarged: $isImage1Enlarged
                    )

                    ExerciseRow(
                        text: selectedCategoryExercises[selectedCategoryExerciseIndex].exercise2,
                        imageName: selectedCategoryExercises[selectedCategoryExerciseIndex].exercise2imgpath,
                        isEnlarged: $isImage2Enlarged
                    )
                }

                Button {
                    if !selectedCategoryExercises.isEmpty {
                        selectedCategoryExerciseIndex = Utilities.generateRandomIndex(excluding: selectedCategoryExerciseIndex, in: 0..<selectedCategoryExercises.count)
                    }
                } label: {
                    Text("Shuffle ✨")
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
            }

            Button {
                randomChallenge = contentDataRandomChallenge?.randomElement()?.challenge ?? "Error: Not available challenge"
                showAlert = true
            } label: {
                Text("Random challenge / task")
                    .font(.system(size: 15, weight: .bold))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 14)
                    .background(
                        LinearGradient(colors: [accent.opacity(0.85), accent2.opacity(0.85)], startPoint: .leading, endPoint: .trailing)
                    )
                    .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
                    .shadow(radius: 8, y: 3)
            }

        }
        .padding(16)
        .background(Color.white.opacity(0.9))
        .clipShape(RoundedRectangle(cornerRadius: 22, style: .continuous))
        .shadow(radius: 10, y: 4)
        .onAppear {
            contentDataRandomChallenge = ContentLoader.loadJSON(fileName: "ContentData/HomeRandomChallenge", type: [HomeRandomChallengeModel].self)
            contentDataRandomExercise = ContentLoader.loadJSON(fileName: "ContentData/HomeRandomExercise", type: [HomeRandomExerciseModel].self)

            if selectedCategory.isEmpty, let first = GlobalData.exerciseCategory.first {
                selectedCategory = first
                selectedCategoryExercises = contentDataRandomExercise?.filter { $0.category == first.lowercased() } ?? []
            }
        }
        .alert(isPresented: $showAlert) {
            Alert(
                title: Text("Random challenge or task"),
                message: Text(randomChallenge),
                dismissButton: .default(Text("OK"))
            )
        }
    }
}

private struct ExerciseRow: View {
    let text: String
    let imageName: String
    @Binding var isEnlarged: Bool

    var body: some View {
        HStack(spacing: 10) {
            Text("• \(text)")
                .font(.system(size: 14, weight: .semibold))
                .foregroundColor(.black.opacity(0.75))
                .lineLimit(2)

            Spacer()

            Image(imageName)
                .resizable()
                .scaledToFit()
                .frame(width: isEnlarged ? 180 : 48, height: isEnlarged ? 180 : 48)
                .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
                .shadow(radius: 6, y: 2)
                .onTapGesture { isEnlarged.toggle() }
        }
        .padding(12)
        .background(Color.black.opacity(0.04))
        .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
    }
}
