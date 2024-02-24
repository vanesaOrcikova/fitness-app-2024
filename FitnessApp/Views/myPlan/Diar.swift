import SwiftUI

//struct Diar: View {
//    var body: some View {
//        Text("Diary")
//    }
//}

struct Diar: View {
    @State private var selectedDate = Date()
    private let calendar = Calendar.current
    
    var body: some View {
        VStack {
            Text("Diary")
                .font(.title)
                .padding(.top, 50)
            
            CalendarView(selectedDate: $selectedDate)
                .padding()
        }
    }
}

struct CalendarView: View {
    @Binding var selectedDate: Date
    
    private let calendar: Calendar = Calendar.current
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMMM yyyy"
        return formatter
    }()
    
    var body: some View {
        VStack {
            Text(dateFormatter.string(from: selectedDate))
                .font(.headline)
            
            DatePicker("", selection: $selectedDate, displayedComponents: [.date])
                .datePickerStyle(GraphicalDatePickerStyle())
                .labelsHidden()
            
            Spacer()
        }
    }
}

#Preview {
    Diar()
}
