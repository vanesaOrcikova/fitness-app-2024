
import SwiftUI
import AVKit

struct HomeView: View {
    @State private var isSettingsPresented = false
    
    var body: some View {
        ScrollView {
               // Text("Welcome to the health and well-being application!")
                   // .font(.system(size: 20))
                Text("Together for health!")
                    .font(.title)
                    .foregroundColor(.black)
                    .padding()
                    .cornerRadius(0)
                    .frame(maxWidth: .infinity, alignment: .topLeading)
                    .offset(y: -80)
            
                Text("\(Date(), formatter: dateFormatter)")
                   //.font(.subheadline)
                    .font(.system(size: 16))
                   .foregroundColor(.black)
                   .offset(y: -95)
                   .padding(.leading, 18)
                   .frame(maxWidth: .infinity, alignment: .topLeading)

                Image("imgHome2")
                    .resizable()
                    .scaledToFill()
                    .frame(maxWidth: .infinity)
                    .frame(height: 250) // Adjust the height as needed
                    .clipped()
                    .offset(y: -85)
            
            VStack {
                WeeklyMoodOverviewTable()
                RandomExerciseChallengeView()
                MotivationalQuoteView()
                ReminderView()
                MiniblogOfMonth()
            }
            
            .offset(y: -82)
            .padding()
        }
        
    }
}

private let dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .long
    //formatter.timeStyle = .none
    return formatter
}()


#Preview {
    HomeView()
}
