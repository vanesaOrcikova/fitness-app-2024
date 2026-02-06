import SwiftUI

struct MyPlanBlogHeaderPager: View {

    @Binding var selection: Int  // 0 = My Plan, 1 = Logout
    var streak: Int
    var done: Int
    var total: Int

    private let accent = Color(red: 0.85, green: 0.20, blue: 0.70)
    private let accent2 = Color(red: 0.98, green: 0.67, blue: 0.83)

    var body: some View {
        TabView(selection: $selection) {

            headerCard(
                title: "My Plan",
                subtitle: "Your daily goals ✨",
                bottomText: "Streak: \(streak) 🔥   Today: \(done)/\(total) ✨",
                icon: "doc.text.fill"
            )
            .tag(0)

            // ✅ Logout karta je len vizuál (button máš nižšie v logout sekcii)
            headerCard(
                title: "Logout",
                subtitle: "Sign out from the app ✨",
                bottomText: "You can sign back anytime 💗",
                icon: "rectangle.portrait.and.arrow.right"
            )
            .tag(1)
        }
        .tabViewStyle(.page(indexDisplayMode: .never))
        .frame(height: 130)
        .padding(.horizontal, 14)
    }

    private func headerCard(
        title: String,
        subtitle: String,
        bottomText: String,
        icon: String
    ) -> some View {

        VStack(alignment: .leading, spacing: 6) {

            HStack {
                Text(title)
                    .font(.system(size: 26, weight: .bold))
                    .foregroundColor(.white)

                Spacer()

                Image(systemName: icon)
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(.white)
                    .padding(10)
                    .background(Color.white.opacity(0.22))
                    .clipShape(Circle())
                    .allowsHitTesting(false)
            }

            Text(subtitle)
                .font(.system(size: 13, weight: .semibold))
                .foregroundColor(.white.opacity(0.9))

            Text(bottomText)
                .font(.system(size: 12, weight: .bold))
                .foregroundColor(.white.opacity(0.95))
                .padding(.top, 4)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.vertical, 18)
        .padding(.horizontal, 16)
        .background(
            LinearGradient(
                colors: [accent, accent2],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
        .clipShape(RoundedRectangle(cornerRadius: 26, style: .continuous))
    }
}

