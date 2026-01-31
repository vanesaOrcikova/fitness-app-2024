import Foundation
import SwiftUI

struct MiniblogOfMonth: View {

    @State private var contentDataMiniblogs: [HomeMiniblogModel]? = []

    private let accent = Color(red: 0.85, green: 0.20, blue: 0.70)
    private let accent2 = Color(red: 0.98, green: 0.67, blue: 0.83)

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {

//            Text("Miniblog of the month")
//                .font(.system(size: 18, weight: .bold))
//                .foregroundColor(.black.opacity(0.85))

            if let miniblogs = contentDataMiniblogs, miniblogs.count > 0 {
                let indexOfMonth = GlobalData.getCurrentMonthIndex()

                ZStack(alignment: .topTrailing) {
                    VStack(alignment: .leading, spacing: 10) {
                        Text(miniblogs[indexOfMonth].subheader)
                            .font(.system(size: 13, weight: .bold))
                            .foregroundColor(.black.opacity(0.7))

                        Text(miniblogs[indexOfMonth].header)
                            .font(.system(size: 18, weight: .bold))
                            .foregroundColor(.black.opacity(0.85))

                        Text(miniblogs[indexOfMonth].text)
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundColor(.black.opacity(0.72))
                            .lineSpacing(4)
                    }
                    .padding(16)
                    .background(
                        LinearGradient(colors: [accent.opacity(0.10), accent2.opacity(0.10)], startPoint: .topLeading, endPoint: .bottomTrailing)
                    )
                    .clipShape(RoundedRectangle(cornerRadius: 22, style: .continuous))
                    .shadow(radius: 10, y: 4)

                    Image(miniblogs[indexOfMonth].imgpath)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 86, height: 86)
                        .clipShape(Circle())
                        .overlay(Circle().stroke(Color.white, lineWidth: 4))
                        .shadow(radius: 8, y: 3)
                        .padding(.top, -20)
                        .padding(.trailing, 10)
                }
            }
        }
        .onAppear {
            contentDataMiniblogs = ContentLoader.loadJSON(fileName: "ContentData/HomeMiniblog", type: [HomeMiniblogModel].self)
        }
    }
}
    

