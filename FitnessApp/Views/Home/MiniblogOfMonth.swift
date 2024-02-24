import Foundation
import SwiftUI

struct MiniblogOfMonth : View{
    @State private var contentDataMiniblogs: [HomeMiniblogModel]? = []
    
    var body: some View {
        VStack {
            if let miniblogs = contentDataMiniblogs, miniblogs.count > 0 {
                
                let indexOfMonth = GlobalData.getCurrentMonthIndex() //februar +1 = marec
                VStack{
                    Text(miniblogs[indexOfMonth].subheader)
                        .font(.system(size: 14).bold())
                        .foregroundColor(.black)
                        .padding(.bottom, 8)
                    
                    Text(miniblogs[indexOfMonth].header)
                        .font(.system(size: 19))
                        .foregroundColor(.black)
                        .padding(.bottom, 8)
                        .offset(y: -12)
                    
                    Text(miniblogs[indexOfMonth].text)
                        .font(.system(size: 14))
                        .foregroundColor(.black)
                        .padding(.horizontal, 16)
                        .offset(y: -20)
                }
                .padding()
                .frame(width: 370)
                .frame(height: .infinity)
                .background(Color.pink.opacity(0.1))
                //.cornerRadius(8)
                .offset(y: 25)
                
                Image(miniblogs[indexOfMonth].imgpath)
                    .resizable()
                    .clipShape(Circle())
                    .frame(maxWidth: 110)
                    .frame(height: 110)
                    .padding(.top, -16)
                    .padding(.leading, 240)
            }
        }
        .onAppear {
            self.contentDataMiniblogs = ContentLoader.loadJSON(fileName: "ContentData/HomeMiniblog", type: [HomeMiniblogModel].self)
        }
    }
}
    

