import SwiftUI

struct FilterSelectionView: View {

    @Binding var selectedTypes: Set<String>
    @Binding var selectedFocusAreas: Set<String>
    @Binding var selectedDifficulties: Set<String>
    @Binding var isPresented: Bool

    // ✅ rovnaká paleta ako Recipes
    private let bg = Color(red: 1.0, green: 0.97, blue: 0.99)
    private let accent = Color(red: 0.85, green: 0.20, blue: 0.70)   // pink
    private let accent2 = Color(red: 0.98, green: 0.67, blue: 0.83)  // light pink

    // ✅ temp = Apply/Reset
    @State private var tempTypes: Set<String> = []
    @State private var tempFocus: Set<String> = []
    @State private var tempDifficulty: Set<String> = []

    // OPTIONS
    private let typeOptions: [(String, String)] = [
        ("hiit", "Hiit"),
        ("warm_up", "Warm up"),
        ("dance", "Dance"),
        ("cardio", "Cardio"),
        ("strength_training", "Strength\ntraining"),
        ("stretching", "Stretching")
    ]

    private let focusOptions: [(String, String)] = [
        ("abs", "ABs"),
        ("back", "Back"),
        ("booty", "Booty"),
        ("arms", "Arms"),
        ("full_body", "Full body"),
        ("legs", "Legs"),
        ("upper_body", "Upper\nbody"),
        ("core", "Core")
    ]

    private let difficultyOptions: [(String, String)] = [
        ("easy", "Easy"),
        ("medium", "Medium"),
        ("advanced", "Advanced")
    ]

    var body: some View {
        ZStack {
            bg.ignoresSafeArea()

            VStack(alignment: .leading, spacing: 14) {

                // HEADER (FILTER + X)
                HStack {
                    Text("FILTER")
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(.black.opacity(0.85))

                    Spacer()

                    Button {
                        isPresented = false
                    } label: {
                        Image(systemName: "xmark")
                            .font(.system(size: 14, weight: .bold))
                            .foregroundColor(.black.opacity(0.7))
                            .padding(10)
                            .background(Color.white.opacity(0.95))
                            .clipShape(Circle())
                            .shadow(radius: 6, y: 2)
                    }
                }
                .padding(.horizontal, 16)
                .padding(.top, 10)

                ScrollView(showsIndicators: false) {
                    VStack(alignment: .leading, spacing: 18) {

                        FilterBlock(
                            title: "Type",
                            options: typeOptions,
                            selection: $tempTypes,
                            accent: accent,
                            accent2: accent2
                        )

                        FilterBlock(
                            title: "Focus Area",
                            options: focusOptions,
                            selection: $tempFocus,
                            accent: accent,
                            accent2: accent2
                        )

                        FilterBlock(
                            title: "Difficulty",
                            options: difficultyOptions,
                            selection: $tempDifficulty,
                            accent: accent,
                            accent2: accent2
                        )

                        // BUTTONS (Apply / Reset) — rovnaké ako Recipes
                        HStack(spacing: 14) {
                            Button {
                                selectedTypes = tempTypes
                                selectedFocusAreas = tempFocus
                                selectedDifficulties = tempDifficulty
                                isPresented = false
                            } label: {
                                Text("Apply")
                                    .font(.system(size: 16, weight: .bold))
                                    .foregroundColor(.white)
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 14)
                                    .background(
                                        LinearGradient(
                                            colors: [accent, accent2],
                                            startPoint: .leading,
                                            endPoint: .trailing
                                        )
                                    )
                                    .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
                                    .shadow(radius: 10, y: 3)
                            }

                            Button {
                                tempTypes.removeAll()
                                tempFocus.removeAll()
                                tempDifficulty.removeAll()
                            } label: {
                                Text("Reset")
                                    .font(.system(size: 16, weight: .bold))
                                    .foregroundColor(accent)
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 14)
                                    .background(Color.white.opacity(0.95))
                                    .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
                                    .shadow(radius: 8, y: 2)
                            }
                        }
                        .padding(.top, 6)
                    }
                    .padding(.horizontal, 16)
                    .padding(.bottom, 18)
                }
            }
        }
        .onAppear {
            tempTypes = selectedTypes
            tempFocus = selectedFocusAreas
            tempDifficulty = selectedDifficulties
        }
        .presentationDetents([.large])
    }
}

// MARK: - Block + Chip style like Recipes

private struct FilterBlock: View {
    let title: String
    let options: [(String, String)]
    @Binding var selection: Set<String>

    let accent: Color
    let accent2: Color

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {

            Text(title)
                .font(.system(size: 14, weight: .bold))
                .foregroundColor(.black.opacity(0.75))

            LazyVGrid(columns: [GridItem(.adaptive(minimum: 90))], spacing: 12) {
                ForEach(options, id: \.0) { key, label in
                    let isOn = selection.contains(key)

                    Button {
                        if isOn { selection.remove(key) }
                        else { selection.insert(key) }
                    } label: {
                        Text(label)
                            .font(.system(size: 13, weight: .bold))
                            .multilineTextAlignment(.center)
                            .lineLimit(2)
                            .minimumScaleFactor(0.85)
                            .foregroundColor(isOn ? .white : .black.opacity(0.75))
                            .frame(maxWidth: .infinity, minHeight: 38)
                            .padding(.vertical, 6)
                            .background(
                                isOn
                                ? LinearGradient(colors: [accent, accent2], startPoint: .leading, endPoint: .trailing)
                                : LinearGradient(colors: [Color.white.opacity(0.95), Color.white.opacity(0.95)], startPoint: .leading, endPoint: .trailing)
                            )
                            .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
                            .shadow(radius: isOn ? 8 : 4, y: 2)
                    }
                    .buttonStyle(.plain)
                }
            }
        }
    }
}
