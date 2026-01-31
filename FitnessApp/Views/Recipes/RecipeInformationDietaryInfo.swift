import SwiftUI

struct RecipeInformationDietaryInfo: View {
    let recipe: RecipesModel
    let accent: Color

    private var items: [String] {
        recipe.dietary
            .components(separatedBy: ";")
            .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
            .filter { !$0.isEmpty }
    }

    private func pretty(_ raw: String) -> String {
        raw.replacingOccurrences(of: "_", with: " ").capitalized
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            ForEach(items, id: \.self) { item in
                HStack(spacing: 10) {
                    Image(systemName: "checkmark.seal.fill")
                        .foregroundColor(accent)

                    Text(pretty(item))
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(.black.opacity(0.75))

                    Spacer()
                }
            }
        }
        .padding()
        .background(Color.white.opacity(0.9))
        .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
        .shadow(radius: 6, y: 2)
    }
}
