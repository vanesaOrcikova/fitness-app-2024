import SwiftUI

struct RecipeInformationNutritionBadge: View {
    let recipe: RecipesModel
    let accent: Color

    private func parts() -> [String] {
        recipe.nutritions
            .components(separatedBy: ";")
            .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
    }

    var body: some View {
        let p = parts()

        VStack(alignment: .leading, spacing: 12) {
            NutritionRow(icon: "flame.fill", label: p.count > 0 ? p[0] : "-", accent: accent)
            NutritionRow(icon: "leaf.fill", label: p.count > 1 ? p[1] : "-", accent: accent)
            NutritionRow(icon: "drop.fill", label: p.count > 2 ? p[2] : "-", accent: accent)
            NutritionRow(icon: "bolt.fill", label: p.count > 3 ? p[3] : "-", accent: accent)
            Text("per portion")
                .font(.system(size: 12, weight: .semibold))
                .foregroundColor(.gray)
        }
        .padding()
        .background(Color.white.opacity(0.9))
        .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
        .shadow(radius: 6, y: 2)
    }
}

private struct NutritionRow: View {
    let icon: String
    let label: String
    let accent: Color

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .foregroundColor(accent)
                .frame(width: 22)

            Text(label)
                .font(.system(size: 14, weight: .semibold))
                .foregroundColor(.black.opacity(0.75))

            Spacer()
        }
    }
}
