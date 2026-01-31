import SwiftUI

struct RecipeDescriptionView: View {
    let recipeData: RecipesModel

    @State private var selectedInfoTab: InfoTab = .ingredients
    @State private var isMoreImagesPresented: Bool = false

    // ✅ pre konzistentný layout
    @State private var isDescriptionExpanded: Bool = false

    private let accent = Color(red: 0.85, green: 0.20, blue: 0.70)
    private let softBg = Color(red: 1.0, green: 0.97, blue: 0.99)

    enum InfoTab: String, CaseIterable {
        case ingredients = "Ingredients"
        case nutrition = "Nutrition"
        case dietary = "Dietary Info"
    }

    private var totalTime: Int { recipeData.waitingtime + recipeData.cookingtime }

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 0) {

                // MARK: - HEADER IMAGE
                ZStack {
                    Image(recipeData.imgpath)
                        .resizable()
                        .scaledToFill()
                        .frame(height: 340)
                        .clipped()

                    LinearGradient(
                        colors: [.black.opacity(0.35), .clear],
                        startPoint: .top,
                        endPoint: .center
                    )
                }

                // MARK: - CONTENT
                VStack(alignment: .leading, spacing: 16) {
                    Text(recipeData.name)
                        .font(.system(size: 26, weight: .bold))
                        .foregroundColor(.black.opacity(0.85))

                    HStack(spacing: 8) {
                        InfoPill(text: "\(totalTime) MIN", color: accent)
                        InfoPill(text: recipeData.difficulty.uppercased(), color: accent.opacity(0.85))
                    }

                    // MARK: - WAITING/COOKING with lines
                    VStack(spacing: 10) {
                        TimeLineRow(
                            title: "WAITING TIME",
                            minutes: recipeData.waitingtime,
                            totalMinutes: max(totalTime, 1),
                            lineColor: accent.opacity(0.65)
                        )
                        TimeLineRow(
                            title: "COOKING TIME",
                            minutes: recipeData.cookingtime,
                            totalMinutes: max(totalTime, 1),
                            lineColor: Color.green.opacity(0.70)
                        )
                    }
                    .padding(.top, 4)

                    Divider().opacity(0.25)

                    // ✅ DESCRIPTION – fixná výška (Information nebude skákať)
                    VStack(alignment: .leading, spacing: 8) {
                        Text(recipeData.description)
                            .font(.system(size: 15))
                            .foregroundColor(.black.opacity(0.70))
                            .lineSpacing(4)
                            .lineLimit(isDescriptionExpanded ? nil : 4) // ✅ fix
                            .frame(maxWidth: .infinity, alignment: .leading)

                        Button {
                            withAnimation(.easeInOut) {
                                isDescriptionExpanded.toggle()
                            }
                        } label: {
                            Text(isDescriptionExpanded ? "Show less" : "Read more")
                                .font(.system(size: 14, weight: .bold))
                                .foregroundColor(accent)
                        }
                    }

                    // ✅ jednotná medzera pred Information
                    .padding(.bottom, 4)

                    // MARK: - INFORMATION + tabs
                    Text("Information")
                        .font(.system(size: 22, weight: .bold))
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.top, 8)

                    InfoTabPicker(selected: $selectedInfoTab, accent: accent)

                    Group {
                        switch selectedInfoTab {
                        case .ingredients:
                            IngredientsCard(ingredientsRaw: recipeData.ingredients, accent: accent)
                        case .nutrition:
                            RecipeInformationNutritionBadge(recipe: recipeData, accent: accent)
                        case .dietary:
                            RecipeInformationDietaryInfo(recipe: recipeData, accent: accent)
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)

                    Divider().opacity(0.25)

                    // MARK: - STEPS
                    Text("Steps")
                        .font(.system(size: 22, weight: .bold))
                        .frame(maxWidth: .infinity, alignment: .leading)

                    StepsCard(stepsRaw: recipeData.recipesteps)

                    // MARK: - MORE IMAGES
                    Button {
                        isMoreImagesPresented = true
                    } label: {
                        Text("More Images")
                            .font(.system(size: 16, weight: .bold))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 14)
                            .background(
                                LinearGradient(
                                    colors: [accent, accent.opacity(0.7)],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
                            .shadow(radius: 10, y: 4)
                    }
                    .padding(.top, 10)
                    .sheet(isPresented: $isMoreImagesPresented) {
                        MoreImagesSheet(buttonImagePaths: recipeData.buttonimagepaths, accent: accent, softBg: softBg)
                    }

                    Spacer(minLength: 20)
                }
                .padding(20)
                .background(softBg)
                .clipShape(RoundedRectangle(cornerRadius: 28, style: .continuous))
                .offset(y: -30)
            }
        }
        .ignoresSafeArea(edges: .top)
        .background(softBg)
    }
}

// MARK: - UI Parts

private struct InfoPill: View {
    let text: String
    let color: Color

    var body: some View {
        Text(text)
            .font(.system(size: 13, weight: .bold))
            .foregroundColor(.white)
            .padding(.horizontal, 12)
            .padding(.vertical, 6)
            .background(color)
            .clipShape(Capsule())
    }
}

private struct TimeLineRow: View {
    let title: String
    let minutes: Int
    let totalMinutes: Int
    let lineColor: Color

    private var progress: CGFloat {
        CGFloat(minutes) / CGFloat(max(totalMinutes, 1))
    }

    var body: some View {
        HStack(spacing: 10) {
            Text(title)
                .font(.system(size: 12, weight: .bold))
                .foregroundColor(.black.opacity(0.55))
                .frame(width: 110, alignment: .leading)

            GeometryReader { geo in
                ZStack(alignment: .leading) {
                    Capsule()
                        .fill(Color.black.opacity(0.08))
                        .frame(height: 6)

                    Capsule()
                        .fill(lineColor)
                        .frame(width: max(10, geo.size.width * progress), height: 6)
                }
            }
            .frame(height: 10)

            Text("\(minutes) MIN")
                .font(.system(size: 12, weight: .bold))
                .foregroundColor(.black.opacity(0.65))
                .frame(width: 60, alignment: .trailing)
        }
    }
}

private struct InfoTabPicker: View {
    @Binding var selected: RecipeDescriptionView.InfoTab
    let accent: Color

    var body: some View {
        HStack(spacing: 8) {
            ForEach(RecipeDescriptionView.InfoTab.allCases, id: \.self) { tab in
                let isOn = selected == tab
                Button {
                    withAnimation { selected = tab }
                } label: {
                    Text(tab.rawValue)
                        .font(.system(size: 13, weight: .bold))
                        .foregroundColor(isOn ? .white : .black.opacity(0.65))
                        .padding(.vertical, 10)
                        .frame(maxWidth: .infinity)
                        .background(isOn ? accent : Color.white.opacity(0.9))
                        .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
                        .shadow(radius: isOn ? 8 : 3, y: 2)
                }
            }
        }
        .padding(.top, 2)
    }
}

private struct IngredientsCard: View {
    let ingredientsRaw: String
    let accent: Color

    private var ingredients: [String] {
        ingredientsRaw
            .components(separatedBy: ";")
            .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
            .filter { !$0.isEmpty }
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            ForEach(ingredients, id: \.self) { ing in
                HStack(spacing: 10) {
                    Circle()
                        .fill(accent.opacity(0.8))
                        .frame(width: 6, height: 6)

                    Text(ing)
                        .font(.system(size: 14))
                        .foregroundColor(.black.opacity(0.75))

                    Spacer()
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(Color.white.opacity(0.9))
        .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
        .shadow(radius: 6, y: 2)
    }
}

private struct StepsCard: View {
    let stepsRaw: String

    private var steps: [String] {
        stepsRaw
            .components(separatedBy: ";")
            .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
            .filter { !$0.isEmpty }
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            ForEach(steps.indices, id: \.self) { i in
                Text("\(i + 1). \(steps[i])")
                    .font(.system(size: 14))
                    .foregroundColor(.black.opacity(0.78))
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(Color.white.opacity(0.9))
        .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
        .shadow(radius: 6, y: 2)
    }
}

private struct MoreImagesSheet: View {
    let buttonImagePaths: String
    let accent: Color
    let softBg: Color

    @Environment(\.dismiss) private var dismiss

    private var images: [String] {
        buttonImagePaths
            .components(separatedBy: ";")
            .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
            .filter { !$0.isEmpty }
    }

    var body: some View {
        ZStack {
            softBg.ignoresSafeArea()

            VStack(spacing: 14) {
                HStack {
                    Text("More Images ✨")
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(.black.opacity(0.8))
                    Spacer()
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark")
                            .font(.system(size: 14, weight: .bold))
                            .foregroundColor(.black.opacity(0.7))
                            .padding(10)
                            .background(Color.white.opacity(0.9))
                            .clipShape(Circle())
                            .shadow(radius: 6, y: 2)
                    }
                }
                .padding(.horizontal, 16)
                .padding(.top, 12)

                if images.isEmpty {
                    Text("No extra images found.")
                        .foregroundColor(.gray)
                        .padding(.top, 40)
                    Spacer()
                } else {
                    ScrollView(showsIndicators: false) {
                        VStack(spacing: 12) {
                            ForEach(images, id: \.self) { imgName in
                                Image(imgName)
                                    .resizable()
                                    .scaledToFit()
                                    .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
                                    .shadow(radius: 10, y: 4)
                                    .padding(.horizontal, 16)
                            }
                        }
                        .padding(.top, 6)
                        .padding(.bottom, 20)
                    }
                }
            }
        }
    }
}

