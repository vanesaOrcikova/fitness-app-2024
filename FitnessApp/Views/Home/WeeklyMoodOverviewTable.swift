//import SwiftUI
//
//struct WeeklyMoodOverviewTable: View {
//
//    @State private var weekArr: [String]
//    @State private var selectedDayIndex = 0
//    @State private var isSheetPresented = false
//
//    private let accent = Color(red: 0.85, green: 0.20, blue: 0.70)
//    private let accent2 = Color(red: 0.98, green: 0.67, blue: 0.83)
//
//    init() {
//        _weekArr = State(initialValue: UserDefaults.standard.weekArray(forKey: "weeklyMoodOverviewTableStorage"))
//        // ak by náhodou prišlo niečo zlé, opravíme dĺžku
//        if _weekArr.wrappedValue.count != 7 {
//            _weekArr = State(initialValue: Array(repeating: "", count: 7))
//        }
//    }
//
//    var body: some View {
//        VStack(alignment: .leading, spacing: 12) {
//
//            Text("Weekly Mood")
//                .font(.system(size: 18, weight: .bold))
//                .foregroundColor(.black.opacity(0.8))
//
//            LazyVGrid(
//                columns: Array(repeating: GridItem(.flexible(), spacing: 10), count: 7),
//                spacing: 12
//            ) {
//                ForEach(0..<min(GlobalData.daysOfWeek.count, 7), id: \.self) { index in
//                    let emoji = weekArr[index]
//                    let hasEmoji = !emoji.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
//
//                    Button {
//                        selectedDayIndex = index
//                        isSheetPresented = true
//                    } label: {
//                        VStack(spacing: 8) {
//                            Text(GlobalData.daysOfWeek[index])
//                                .font(.system(size: 12, weight: .bold))
//                                .foregroundColor(.black.opacity(0.65))
//
//                            MoodSquare(
//                                hasEmoji: hasEmoji,
//                                emoji: emoji,
//                                accent: accent,
//                                accent2: accent2
//                            )
//                        }
//                        .padding(.vertical, 10)
//                        .frame(maxWidth: .infinity)
//                        .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
//                        .shadow(radius: 8, y: 3)
//                    }
//                    .buttonStyle(.plain)
//                }
//            }
//        }
//        .padding(16)
//        .background(
//            LinearGradient(
//                colors: [accent.opacity(0.12), accent2.opacity(0.10)],
//                startPoint: .topLeading,
//                endPoint: .bottomTrailing
//            )
//        )
//        .clipShape(RoundedRectangle(cornerRadius: 22, style: .continuous))
//        .shadow(radius: 10, y: 4)
//        .sheet(isPresented: $isSheetPresented) {
//            SelectableMoodOverviewSheet(
//                weekArr: $weekArr,
//                selectedWeekArrIndex: $selectedDayIndex,
//                isSheetPresented: $isSheetPresented
//            )
//        }
//        .onChange(of: weekArr) { newValue in
//            UserDefaults.standard.setWeekArray(newValue, forKey: "weeklyMoodOverviewTableStorage")
//        }
//    }
//}
//
//private struct MoodSquare: View {
//    let hasEmoji: Bool
//    let emoji: String
//    let accent: Color
//    let accent2: Color
//
//    private var bgGradient: LinearGradient {
//        if hasEmoji {
//            return LinearGradient(
//                colors: [accent.opacity(0.22), accent2.opacity(0.22)],
//                startPoint: .topLeading,
//                endPoint: .bottomTrailing
//            )
//        } else {
//            return LinearGradient(
//                colors: [accent.opacity(0.10), accent2.opacity(0.10)],
//                startPoint: .topLeading,
//                endPoint: .bottomTrailing
//            )
//        }
//    }
//
//    private var borderOpacity: Double {
//        hasEmoji ? 0.20 : 0.35
//    }
//
//    private var shadowRadius: CGFloat {
//        hasEmoji ? 6 : 2
//    }
//
//    var body: some View {
//        ZStack {
//            if hasEmoji {
//                Text(emoji)
//                    .font(.system(size: 28))
//            } else {
//                RoundedRectangle(cornerRadius: 14, style: .continuous)
//                    .stroke(accent.opacity(borderOpacity), lineWidth: 1.5)
//            }
//        }
//        .frame(width: 44, height: 44)
//        .background(bgGradient)
//        .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
//        .shadow(radius: shadowRadius, y: 2)
//    }
//}
//
//// MARK: - Sheet (now in scope)
//
//struct SelectableMoodOverviewSheet: View {
//    @Binding var weekArr: [String]
//    @Binding var selectedWeekArrIndex: Int
//    @Binding var isSheetPresented: Bool
//
//    private let bg = Color(red: 1.0, green: 0.97, blue: 0.99)
//    private let accent = Color(red: 0.85, green: 0.20, blue: 0.70)
//    private let accent2 = Color(red: 0.98, green: 0.67, blue: 0.83)
//
//    var body: some View {
//        ZStack {
//            bg.ignoresSafeArea()
//
//            VStack(spacing: 12) {
//                HStack {
//                    Text("How do you feel today?")
//                        .font(.system(size: 18, weight: .bold))
//                        .foregroundColor(.black.opacity(0.85))
//
//                    Spacer()
//
//                    Button {
//                        isSheetPresented = false
//                    } label: {
//                        Image(systemName: "xmark")
//                            .font(.system(size: 14, weight: .bold))
//                            .foregroundColor(.black.opacity(0.7))
//                            .padding(10)
//                            .background(Color.white.opacity(0.9))
//                            .clipShape(Circle())
//                            .shadow(radius: 6, y: 2)
//                    }
//                }
//                .padding(.horizontal)
//                .padding(.top, 10)
//
//                ScrollView(showsIndicators: false) {
//                    LazyVGrid(columns: [GridItem(.adaptive(minimum: 60))], spacing: 14) {
//                        ForEach(GlobalData.emoji, id: \.self) { icon in
//                            Button {
//                                if weekArr.indices.contains(selectedWeekArrIndex) {
//                                    weekArr[selectedWeekArrIndex] = icon
//                                }
//                                isSheetPresented = false
//                            } label: {
//                                Text(icon)
//                                    .font(.system(size: 30))
//                                    .frame(width: 56, height: 56)
//                                    .background(
//                                        LinearGradient(
//                                            colors: [accent.opacity(0.14), accent2.opacity(0.14)],
//                                            startPoint: .topLeading,
//                                            endPoint: .bottomTrailing
//                                        )
//                                    )
//                                    .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
//                                    .shadow(radius: 8, y: 3)
//                            }
//                        }
//                    }
//                    .padding(.horizontal)
//                    .padding(.top, 10)
//                    .padding(.bottom, 18)
//                }
//            }
//        }
//        .presentationDetents([.medium, .large])
//    }
//}

import SwiftUI
import WidgetKit

struct WeeklyMoodOverviewTable: View {

    @State private var weekArr: [String]
    @State private var selectedDayIndex = 0
    @State private var isSheetPresented = false

    private let accent = Color(red: 0.85, green: 0.20, blue: 0.70)
    private let accent2 = Color(red: 0.98, green: 0.67, blue: 0.83)

    init() {
        _weekArr = State(initialValue: UserDefaults.standard.weekArrayShared(forKey: "weeklyMoodOverviewTableStorage"))

        if _weekArr.wrappedValue.count != 7 {
            _weekArr = State(initialValue: Array(repeating: "", count: 7))
        }
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {

            Text("Weekly Mood")
                .font(.system(size: 18, weight: .bold))
                .foregroundColor(.black.opacity(0.8))

            LazyVGrid(
                columns: Array(repeating: GridItem(.flexible(), spacing: 10), count: 7),
                spacing: 12
            ) {
                ForEach(0..<min(GlobalData.daysOfWeek.count, 7), id: \.self) { index in
                    let emoji = weekArr[index]
                    let hasEmoji = !emoji.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty

                    Button {
                        selectedDayIndex = index
                        isSheetPresented = true
                    } label: {
                        VStack(spacing: 8) {
                            Text(GlobalData.daysOfWeek[index])
                                .font(.system(size: 12, weight: .bold))
                                .foregroundColor(.black.opacity(0.65))

                            MoodSquare(
                                hasEmoji: hasEmoji,
                                emoji: emoji,
                                accent: accent,
                                accent2: accent2
                            )
                        }
                        .padding(.vertical, 10)
                        .frame(maxWidth: .infinity)
                        .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
                        .shadow(radius: 8, y: 3)
                    }
                    .buttonStyle(.plain)
                }
            }
        }
        .padding(16)
        .background(
            LinearGradient(
                colors: [accent.opacity(0.12), accent2.opacity(0.10)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
        .clipShape(RoundedRectangle(cornerRadius: 22, style: .continuous))
        .shadow(radius: 10, y: 4)
        .sheet(isPresented: $isSheetPresented) {
            SelectableMoodOverviewSheet(
                weekArr: $weekArr,
                selectedWeekArrIndex: $selectedDayIndex,
                isSheetPresented: $isSheetPresented
            )
        }
        .onChange(of: weekArr) { newValue in
            // ✅ ulož celý týždeň do App Group
            UserDefaults.standard.setWeekArrayShared(newValue, forKey: "weeklyMoodOverviewTableStorage")

            // ✅ refresh widgetu
            WidgetCenter.shared.reloadAllTimelines()
        }
    }
}

private struct MoodSquare: View {
    let hasEmoji: Bool
    let emoji: String
    let accent: Color
    let accent2: Color

    private var bgGradient: LinearGradient {
        if hasEmoji {
            return LinearGradient(
                colors: [accent.opacity(0.22), accent2.opacity(0.22)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        } else {
            return LinearGradient(
                colors: [accent.opacity(0.10), accent2.opacity(0.10)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        }
    }

    private var borderOpacity: Double {
        hasEmoji ? 0.20 : 0.35
    }

    private var shadowRadius: CGFloat {
        hasEmoji ? 6 : 2
    }

    var body: some View {
        ZStack {
            if hasEmoji {
                Text(emoji)
                    .font(.system(size: 28))
            } else {
                RoundedRectangle(cornerRadius: 14, style: .continuous)
                    .stroke(accent.opacity(borderOpacity), lineWidth: 1.5)
            }
        }
        .frame(width: 44, height: 44)
        .background(bgGradient)
        .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
        .shadow(radius: shadowRadius, y: 2)
    }
}

// MARK: - Sheet

struct SelectableMoodOverviewSheet: View {
    @Binding var weekArr: [String]
    @Binding var selectedWeekArrIndex: Int
    @Binding var isSheetPresented: Bool

    private let bg = Color(red: 1.0, green: 0.97, blue: 0.99)
    private let accent = Color(red: 0.85, green: 0.20, blue: 0.70)
    private let accent2 = Color(red: 0.98, green: 0.67, blue: 0.83)

    var body: some View {
        ZStack {
            bg.ignoresSafeArea()

            VStack(spacing: 12) {
                HStack {
                    Text("How do you feel today?")
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(.black.opacity(0.85))

                    Spacer()

                    Button {
                        isSheetPresented = false
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
                .padding(.horizontal)
                .padding(.top, 10)

                ScrollView(showsIndicators: false) {
                    LazyVGrid(columns: [GridItem(.adaptive(minimum: 60))], spacing: 14) {
                        ForEach(GlobalData.emoji, id: \.self) { icon in
                            Button {
                                if weekArr.indices.contains(selectedWeekArrIndex) {
                                    weekArr[selectedWeekArrIndex] = icon
                                }

                                // ✅ najdôležitejšie: ulož “posledne zvolený mood”
                                UserDefaults.standard.setLastMoodShared(emoji: icon, dayIndex: selectedWeekArrIndex)

                                // ✅ refresh widget
                                WidgetCenter.shared.reloadAllTimelines()

                                isSheetPresented = false
                            } label: {
                                Text(icon)
                                    .font(.system(size: 30))
                                    .frame(width: 56, height: 56)
                                    .background(
                                        LinearGradient(
                                            colors: [accent.opacity(0.14), accent2.opacity(0.14)],
                                            startPoint: .topLeading,
                                            endPoint: .bottomTrailing
                                        )
                                    )
                                    .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                                    .shadow(radius: 8, y: 3)
                            }
                        }
                    }
                    .padding(.horizontal)
                    .padding(.top, 10)
                    .padding(.bottom, 18)
                }
            }
        }
        .presentationDetents([.medium, .large])
    }
}
