import Foundation
import SwiftUI

struct ReminderView :View{
    @State private var contentDataReminders: [HomeReminderModel]? = []
    
    var body : some View{
        VStack {
            Text("Reminders:")
                .font(.headline)
                .padding(.top, 16)
            
            let dayIndex = GlobalData.getCurrentDayIndex(); //+1
            if let reminders = self.contentDataReminders, !reminders.isEmpty { //je logická podmienka, ktorá kontroluje, či pole reminders nie je prázdne. Symbol ! pred výrazom reminders.isEmpty znamená negáciu, teda "nie je prázdne"
                Text(reminders[dayIndex].reminder1)
                Text(reminders[dayIndex].reminder2)
                Text(reminders[dayIndex].reminder3)
            } else {
                Text("ERROR: No reminders available.")
            }
        }
        .padding()
        .background(Color.green.opacity(0.1))
        .cornerRadius(8)
        .onAppear{
            self.contentDataReminders = ContentLoader.loadJSON(fileName: "ContentData/HomeReminder", type: [HomeReminderModel].self)
        }
        //.padding()
        .offset(y: 20)
    }
}

