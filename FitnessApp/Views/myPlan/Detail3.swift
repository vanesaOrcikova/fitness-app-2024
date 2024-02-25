import SwiftUI

struct Detail3: View {
    let imageName = "thePower" // Nastavte název jednoho obrázku

    var body: some View {
        ScrollView {
            VStack {
                Image(imageName)
                    .resizable()
                    .frame(maxWidth: 390)
                    .frame(height: 350)
                    .padding(.top, -100)
                
                Text("The power of silence")
                    .font(.system(size: 23))
                    .padding(.trailing, 315)
                    .padding(.top, 10)
                
                HStack {
                    ZStack {
                        RoundedRectangle(cornerRadius: 1)
                            .foregroundColor(.purple)
                            .frame(height: 30)
                            .frame(width: 75)
                        
                        Text("HEALTH")
                            .font(.system(size: 16))
                            .bold()
                            .foregroundColor(.white)
                            .font(.headline)
                    }
                    
                    
                    ZStack {
                        RoundedRectangle(cornerRadius: 1)
                            .foregroundColor(.purple)
                            .frame(height: 30)
                            .frame(width: 60)
                        
                        Text("FOOD")
                            .font(.system(size: 16))
                            .bold()
                            .foregroundColor(.white)
                            .font(.headline)
                    }
                    
                    
                }
                .padding(.trailing, 190)
                
                Text("--------------------------------------------")
                    .foregroundColor(.purple) // Farebná čiarka
                
                VStack{
                    Text("Is your TV talking non stop? Are you constantly listening to music? Do you always need SOME noise around you? \n\n People say there is magic in the early morning hours (for example at 5am), also because the world is still so silent. If you are not an early bird (I'm not either haha) I still encourage you to have some time with absolute silence during your day. It's amazing for your brain, mental clarity and a necessary break of our loud world. It's definitely hard if people are around you, so try to do it when you are alone.")
                        .padding(.horizontal, 20)
                        .padding(.top, 10)
                        .fixedSize(horizontal: false, vertical: true)
                    
                    Text("My possible moments of silence:")
                        .font(.system(size: 19))
                        .padding(.top, 20)
                        .fixedSize(horizontal: false, vertical: true)
                    
                    Text("- After a workout, I sometimes turn off the music, close my laptop and just sit there.\nSounds weird, but it's so good!\n- Sometimes I like to wake up before everybody else (that's not 5am though) & do some stretching or deep breathing. There is some magic when everybody else (in your house) is still sleeping!\n- When doing my make up in the morning + oil pulling = I cannot even talk and nobody can ask me questions.\n- During creative work, I can concentrate best if it's fully silent. e.g. when writing texts like this one, brainstorming...\n- Getting ready for bed: Alone in the bathroom, washing off make up etc. - a great moment for silent selfcare!\n- Shortly before bedtime: I turn off the big lights, only have a small one next to my bed, no phone screens. Maybe I read a book, maybe I journal & write something down... in silence.")
                        .padding(.horizontal, 20)
                    //.padding(.top, 10)
                        .fixedSize(horizontal: false, vertical: true)
                    
                    //                        ScrollView(.horizontal) {
                    //                            HStack(spacing: 10) {
                    //                                ForEach(imageNames, id: \.self) { imageName in
                    //                                    Image(imageName)
                    //                                        .resizable()
                    //                                        .frame(width: 160, height: 130)
                    //                                        .cornerRadius(1)
                    //                                }
                    //                            }
                    //                            .padding(.horizontal, 20)
                    //
                    //
                    //                        }
                    
                    
                    ScrollView(.horizontal) {
                        HStack(spacing: 10) {
                            ImageViewWithText(imageName: "food", text: "mal si pravdu je to cista cista cista kraaaaaaasa a este ovela ovela viac")
                            ImageViewWithText(imageName: "food", text: "mal si pravdu je to cista cista cista cista kraaaaaaasa")
                            ImageViewWithText(imageName: "food", text: "Ahoj no co je to krajsie")
                        }
                        .padding(.horizontal, 20)
                    }
                    
                }
                
            }
        }
    }
}

struct ImageViewWithText: View {
    let imageName: String
    let text: String
    @State private var isTextVisible = false
    
    var body: some View {
        ZStack {
            if !isTextVisible {
                Image(imageName)
                    .resizable()
                    .frame(width: 150, height: 120)
                    .cornerRadius(2)
                    .onTapGesture {
                        isTextVisible.toggle()
                    }
            }
            if isTextVisible {
                Text(text)
                    .foregroundColor(.white)
                    .padding(8)
                    .background(Color.black.opacity(0.7))
                    .cornerRadius(2) // Match the corner radius of the image
                    .frame(width: 160, height: 120) // Match the size of the image
                    .multilineTextAlignment(.leading) // Align text to leading edge
                    .lineLimit(nil)
                    .onTapGesture {
                        isTextVisible.toggle()
                    }
                    .clipped()
            }
        }
    }
}


#Preview {
    Detail3()
}
