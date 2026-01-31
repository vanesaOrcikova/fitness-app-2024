import SwiftUI
import AVKit
import HalfASheet

struct RecipesView: View {
    @State private var contentDataRecipes: [RecipesModel]? = []

    @State private var searchText: String = ""
    @State private var isSearching = false

    // debounce
    @State private var debouncedSearchText: String = ""
    @State private var debounceTask: Task<Void, Never>? = nil

    // Filter
    @State private var selectedCategories: Set<String> = []
    @State private var isFilterSelectionSheetPresented = false

    // Sort
    @State private var selectedNewestOption: String = "Newest"
    @State private var isNewestSelectionSheetPresented = false

    // Girly palette
    private let bg = Color(red: 1.0, green: 0.97, blue: 0.99)
    private let accent = Color(red: 0.85, green: 0.20, blue: 0.70)
    private let accent2 = Color(red: 0.98, green: 0.67, blue: 0.83)
    private let card = Color.white.opacity(0.9)

    private var filteredAndSortedRecipes: [RecipesModel] {
        guard let recipes = contentDataRecipes else { return [] }
        var result = recipes

        if !selectedCategories.isEmpty {
            result = result.filter { recipe in
                let recipeCats = Set(recipe.category)
                return !recipeCats.isDisjoint(with: selectedCategories)
            }
        }

        let trimmed = debouncedSearchText.trimmingCharacters(in: .whitespacesAndNewlines)
        if !trimmed.isEmpty {
            result = result.filter { recipe in
                recipe.name.localizedCaseInsensitiveContains(trimmed)
            }
        }

        if selectedNewestOption == "Newest" {
            result = result.sorted { $0.id > $1.id }
        } else if selectedNewestOption == "Quickest" {
            result = result.sorted { a, b in
                (a.waitingtime + a.cookingtime) < (b.waitingtime + b.cookingtime)
            }
        } else if selectedNewestOption == "Easiest" {
            func difficultyRank(_ d: String) -> Int {
                let v = d.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
                if v == "easy" { return 0 }
                if v == "medium" { return 1 }
                if v == "hard" { return 2 }
                return 3
            }
            result = result.sorted { a, b in
                let ra = difficultyRank(a.difficulty)
                let rb = difficultyRank(b.difficulty)
                if ra != rb { return ra < rb }
                return (a.waitingtime + a.cookingtime) < (b.waitingtime + b.cookingtime)
            }
        }

        return result
    }

    var body: some View {
        ZStack {
            bg.ignoresSafeArea()

            ScrollView(showsIndicators: false) {
                VStack(spacing: 12) {

                    // ✅ HEADER – stabilné odsadenie (ako HomeView)
                    VStack(spacing: 6) {
                        Text("Recipes")
                            .font(.system(size: 26, weight: .bold))
                            .foregroundColor(.white)

                        Text("Find something yummy ✨")
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
                    .padding(.top, -100) // ✅ jemný odstup od safe area

                    // SEARCH
                    HStack(spacing: 10) {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.gray.opacity(0.9))

                        TextField("What would you like to eat?", text: $searchText)
                            .autocapitalization(.none)
                            .font(.system(size: 16, weight: .medium))
                            .onTapGesture { withAnimation { isSearching = true } }
                            .onChange(of: searchText) { newValue in
                                debounceTask?.cancel()
                                debounceTask = Task {
                                    try? await Task.sleep(nanoseconds: 220_000_000)
                                    if Task.isCancelled { return }
                                    await MainActor.run {
                                        debouncedSearchText = newValue
                                    }
                                }
                            }

                        if isSearching && (!searchText.isEmpty) {
                            Button {
                                withAnimation {
                                    searchText = ""
                                    debouncedSearchText = ""
                                    isSearching = false
                                }
                            } label: {
                                Image(systemName: "xmark.circle.fill")
                                    .foregroundColor(.gray.opacity(0.8))
                            }
                        }
                    }
                    .padding(.horizontal, 14)
                    .padding(.vertical, 12)
                    .background(card)
                    .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                    .shadow(radius: 8, y: 3)
                    .padding(.horizontal, 14)

                    // FILTER + SORT
                    HStack(spacing: 12) {
                        AestheticPillButton(
                            title: "FILTER",
                            systemIcon: "slider.horizontal.3",
                            accent: accent
                        ) {
                            isFilterSelectionSheetPresented.toggle()
                        }
                        .sheet(isPresented: $isFilterSelectionSheetPresented) {
                            FilterSelectionView2(
                                selectedCategories: $selectedCategories,
                                isSheetPresented: $isFilterSelectionSheetPresented,
                                accent: accent,
                                bg: bg
                            )
                        }

                        AestheticPillButton(
                            title: "SORT BY",
                            systemIcon: "sparkles",
                            accent: accent
                        ) {
                            isNewestSelectionSheetPresented.toggle()
                        }
                        .sheet(isPresented: $isNewestSelectionSheetPresented) {
                            NewestSelectionView(
                                selectedFilter: $selectedNewestOption,
                                isSheetPresented: $isNewestSelectionSheetPresented,
                                accent: accent,
                                bg: bg
                            )
                        }
                    }
                    .padding(.horizontal, 14)

                    // sort label
                    if !selectedNewestOption.isEmpty {
                        ActiveChipRow(
                            title: "Sort:",
                            value: selectedNewestOption,
                            accent: accent
                        )
                        .padding(.horizontal, 14)
                        .padding(.top, 2)
                    }

                    // GRID
                    let gridLayout = [GridItem(.flexible()), GridItem(.flexible())]
                    LazyVGrid(columns: gridLayout, spacing: 12) {
                        ForEach(filteredAndSortedRecipes, id: \.id) { recipe in
                            NavigationLink(destination: RecipeDescriptionView(recipeData: recipe)) {
                                RecipesViewScrollTemplateElement(recipeData: recipe)
                                    .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
                                    .shadow(radius: 10, y: 4)
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                    }
                    .padding(.horizontal, 14)
                    .padding(.top, 4)
                    .padding(.bottom, 22)
                }
                .padding(.bottom, 16)
            }
        }
        .onAppear {
            // ✅ optional fix
            self.contentDataRecipes = ContentLoader.loadJSON(
                fileName: "ContentData/Recipes",
                type: [RecipesModel].self
            ) ?? []
            debouncedSearchText = searchText
            if selectedNewestOption.isEmpty { selectedNewestOption = "Newest" }
        }
    }
}

// MARK: - Components

private struct AestheticPillButton: View {
    let title: String
    let systemIcon: String
    let accent: Color
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 8) {
                Image(systemName: systemIcon)
                    .font(.system(size: 14, weight: .bold))
                    .foregroundColor(.white)
                    .padding(8)
                    .background(
                        LinearGradient(
                            colors: [accent, accent.opacity(0.7)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .clipShape(Circle())

                Text(title)
                    .font(.system(size: 15, weight: .bold))
                    .foregroundColor(.black.opacity(0.75))

                Spacer()
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 12)
            .background(Color.white.opacity(0.9))
            .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
            .shadow(radius: 6, y: 2)
        }
    }
}

private struct ActiveChipRow: View {
    let title: String
    let value: String
    let accent: Color

    var body: some View {
        HStack(spacing: 8) {
            Text(title)
                .font(.system(size: 12, weight: .bold))
                .foregroundColor(accent)

            Text(value)
                .font(.system(size: 12, weight: .semibold))
                .foregroundColor(.black.opacity(0.7))
                .lineLimit(1)

            Spacer()
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 10)
        .background(Color.white.opacity(0.85))
        .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
    }
}

struct FilterSelectionView2: View {
    @Binding var selectedCategories: Set<String>
    @Binding var isSheetPresented: Bool

    @State private var tempSelected: Set<String> = []
    @Environment(\.presentationMode) var presentationMode

    let accent: Color
    let bg: Color

    let filterOptions = ["Snacks", "Desserts", "Dinner", "Lunch", "Breakfast", "Salads", "Soups", "Drinks", "Meal Prep"]

    var body: some View {
        ZStack {
            bg.ignoresSafeArea()

            VStack(spacing: 12) {
                HStack {
                    Text("FILTER")
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(.black.opacity(0.8))

                    Spacer()

                    Button {
                        presentationMode.wrappedValue.dismiss()
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
                .padding(.top, 10)

                LazyVGrid(columns: [GridItem(.adaptive(minimum: 90))], spacing: 12) {
                    ForEach(filterOptions, id: \.self) { item in
                        let isOn = tempSelected.contains(item)
                        Button {
                            if isOn { tempSelected.remove(item) } else { tempSelected.insert(item) }
                        } label: {
                            Text(item)
                                .font(.system(size: 13, weight: .bold))
                                .foregroundColor(isOn ? .white : .black.opacity(0.7))
                                .padding(.vertical, 10)
                                .frame(maxWidth: .infinity)
                                .background(isOn ? accent : Color.white.opacity(0.9))
                                .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
                                .shadow(radius: isOn ? 8 : 4, y: 2)
                        }
                    }
                }
                .padding(.horizontal, 16)
                .padding(.top, 6)

                HStack(spacing: 12) {
                    Button {
                        selectedCategories = tempSelected
                        isSheetPresented = false
                    } label: {
                        Text("Apply")
                            .font(.system(size: 16, weight: .bold))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 14)
                            .background(accent)
                            .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                            .shadow(radius: 10, y: 3)
                    }

                    Button {
                        tempSelected.removeAll()
                    } label: {
                        Text("Reset")
                            .font(.system(size: 16, weight: .bold))
                            .foregroundColor(accent)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 14)
                            .background(Color.white.opacity(0.95))
                            .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                            .shadow(radius: 8, y: 2)
                    }
                }
                .padding(.horizontal, 16)
                .padding(.top, 6)

                Spacer()
            }
        }
        .onAppear { tempSelected = selectedCategories }
    }
}

struct NewestSelectionView: View {
    @Binding var selectedFilter: String
    @Binding var isSheetPresented: Bool

    @State private var selectedNewestOption: String = ""
    @Environment(\.presentationMode) var presentationMode

    let accent: Color
    let bg: Color

    let newestOptions = ["Newest", "Quickest", "Easiest"]

    var body: some View {
        ZStack {
            bg.ignoresSafeArea()

            VStack(spacing: 12) {
                HStack {
                    Text("SORT BY")
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(.black.opacity(0.8))

                    Spacer()

                    Button {
                        presentationMode.wrappedValue.dismiss()
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
                .padding(.top, 10)

                VStack(spacing: 10) {
                    ForEach(newestOptions, id: \.self) { option in
                        let isOn = selectedFilter == option
                        Button {
                            selectedNewestOption = option
                            selectedFilter = option
                            withAnimation {
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                                    presentationMode.wrappedValue.dismiss()
                                }
                            }
                        } label: {
                            HStack {
                                Text(option)
                                    .font(.system(size: 15, weight: .bold))
                                    .foregroundColor(isOn ? .white : .black.opacity(0.75))
                                Spacer()
                                if isOn {
                                    Image(systemName: "checkmark")
                                        .font(.system(size: 14, weight: .bold))
                                        .foregroundColor(.white)
                                }
                            }
                            .padding(.horizontal, 16)
                            .padding(.vertical, 14)
                            .background(isOn ? accent : Color.white.opacity(0.9))
                            .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                            .shadow(radius: isOn ? 10 : 6, y: 2)
                        }
                        .padding(.horizontal, 16)
                    }
                }

                Spacer()
            }
        }
    }
}
