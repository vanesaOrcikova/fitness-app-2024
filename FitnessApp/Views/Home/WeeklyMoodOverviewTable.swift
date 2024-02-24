import SwiftUI

struct WeeklyMoodOverviewTable: View {
    @State private var weekArr: [String]
    @State private var selectedDayIndex = 0
    @State private var isSheetPresented = false

    init(){
        _weekArr = State(initialValue: UserDefaults.standard.weekArray(forKey: "weeklyMoodOverviewTableStorage"))
    }
    
    var body: some View {
        LazyVGrid(columns: Array(repeating: GridItem(), count: 7)) {
            ForEach(0..<GlobalData.daysOfWeek.count, id: \.self) { index in
                Button(action: {
                    selectedDayIndex = index
                    isSheetPresented.toggle()
                }) {
                    VStack {
                        Text(GlobalData.daysOfWeek[index])
                            .font(.headline)
                            .foregroundColor(.primary)
                        
                        Text(weekArr[index])
                            .font(.system(size: 30))
                            .frame(width: 45, height: 45)
                            .background(Color.gray.opacity(0.2))
                            .cornerRadius(8)
                    }
                }
            }
        }
        .sheet(isPresented: $isSheetPresented) {
                   SelectableMoodOverviewSheet(weekArr: $weekArr, selectedWeekArrIndex: $selectedDayIndex, isSheetPresented: $isSheetPresented)
               }
       .onChange(of: weekArr) { newValue in
           UserDefaults.standard.setWeekArray(newValue, forKey: "weeklyMoodOverviewTableStorage")
       }
    }
}

struct SelectableMoodOverviewSheet: View {
    @Binding var weekArr: [String]
    @Binding var selectedWeekArrIndex: Int
    @Binding var isSheetPresented: Bool

    var body: some View {
        VStack {
            Text("How do you feel today?")
                .font(.title)
                .padding()
            
            ScrollView {
                LazyVGrid(columns: [GridItem(.adaptive(minimum: 60))], spacing: 14) {
                    ForEach(GlobalData.emoji, id: \.self) { icon in
                        Button(action: {
                            weekArr[selectedWeekArrIndex] = icon
                            isSheetPresented = false
                        }) {
                            Text(icon)
                                .font(.system(size: 30))
                                .frame(width: 50, height: 50)
                                .background(Color.gray.opacity(0.2))
                                .cornerRadius(8)
                        }
                    }
                }
               .padding()
            }
        }
    }
}
