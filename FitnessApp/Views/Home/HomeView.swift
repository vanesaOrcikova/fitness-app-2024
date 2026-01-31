import SwiftUI
import AVKit

struct HomeView: View {

    private let bg = Color(red: 1.0, green: 0.97, blue: 0.99)
    private let accent = Color(red: 0.85, green: 0.20, blue: 0.70)
    private let accent2 = Color(red: 0.98, green: 0.67, blue: 0.83)

    var body: some View {
        ZStack {
            bg.ignoresSafeArea()

            ScrollView(showsIndicators: false) {
                VStack(spacing: 10) {

                    VStack(spacing: 8) {
                        Text("Together for health!")
                            .font(.system(size: 26, weight: .bold))
                            .foregroundColor(.white)

                        Text("\(Date(), formatter: dateFormatter)")
                            .font(.system(size: 14, weight: .semibold))
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

                    // HERO IMAGE
                    Image("imgHome2")
                        .resizable()
                        .scaledToFill()
                        .frame(height: 260)
                        .frame(maxWidth: .infinity)
                        .clipped()
                        .clipShape(RoundedRectangle(cornerRadius: 22, style: .continuous))
                        .shadow(radius: 10, y: 4)
                        .padding(.horizontal, 14)

                    WeeklyMoodOverviewTable()
                        .padding(.horizontal, 14)

                    RandomExerciseChallengeView()
                        .padding(.horizontal, 14)

                    MotivationalQuoteView()
                        .padding(.horizontal, 14)

                    ReminderView()
                        .padding(.horizontal, 14)

                    MiniblogOfMonth()
                        .padding(.horizontal, 14)

                    Spacer(minLength: 16)
                }
                .padding(.bottom, 16)
            }
        }
    }
}

private let dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .long
    return formatter
}()

#Preview {
    HomeView()
}
