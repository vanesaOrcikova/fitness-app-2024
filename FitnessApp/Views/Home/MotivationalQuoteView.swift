import Foundation
import SwiftUI

struct MotivationalQuoteView: View {

    @State private var contentDataMotivationQuote: [HomeMotivationQuoteModel]? = []

    // 🎀 girly accent colors (rovnaký štýl ako Recipes / Workouts)
    private let accent = Color(red: 0.85, green: 0.20, blue: 0.70)
    private let accent2 = Color(red: 0.98, green: 0.67, blue: 0.83)

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {

            Text("Motivational Quote")
                .font(.system(size: 18, weight: .bold))
                .foregroundColor(.black.opacity(0.85))

            if let quotes = contentDataMotivationQuote,
               !quotes.isEmpty {

                let index = GlobalData.getCurrentDayIndex() % quotes.count

                Text(quotes[index].quote ?? "You are stronger than you think ✨")
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundColor(.black.opacity(0.75))
                    .lineSpacing(4)
                    .padding(.top, 2)

            } else {
                Text("Stay positive and keep going 💕")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(.gray)
            }
        }
        .padding(16)
        .background(
            LinearGradient(
                colors: [
                    accent.opacity(0.12),
                    accent2.opacity(0.12)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
        .clipShape(RoundedRectangle(cornerRadius: 22, style: .continuous))
        .shadow(radius: 10, y: 4)
        .onAppear {
            contentDataMotivationQuote = ContentLoader.loadJSON(
                fileName: "ContentData/HomeMotivationQuote",
                type: [HomeMotivationQuoteModel].self
            )
        }
    }
}
