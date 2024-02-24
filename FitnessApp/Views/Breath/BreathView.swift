import SwiftUI

struct BreathView: View {
    @State private var currentType: BreatheType = sampleTypes[0]
    @Namespace private var animation
    @State private var showBreatheView = false
    @State private var startAnimation = false
    @State private var timerCount: CGFloat = 0
    @State private var breatheAction = "Get ready... "
    @State private var count = 0
    
    var body: some View {
        ZStack {
            Background()
            Content()
            Text(breatheAction)
                .font(.largeTitle)
                .foregroundColor(.white)
                .frame(maxHeight: .infinity, alignment: .top)
                .padding(.top, 50)
                .opacity(showBreatheView ? 1 : 0)
                .animation(.easeInOut(duration: 1), value: breatheAction)
                .animation(.easeInOut(duration: 1), value: showBreatheView)
        }
        .onReceive(Timer.publish(every: 0.01, on: .main, in: .common).autoconnect()) { _ in
            updateTimer()
        }
    }
    
    private func updateTimer() {
        if showBreatheView {
            var duration: Double = 0
            switch currentType.color {
            case lightPinkColor: duration = 4
            case lightPurpleColor: duration = 7
            case lightBlueColor: duration = 3
            default: duration = 0
            }
            updateBreatheActionAndAnimation(duration: duration)
        } else {
            timerCount = 0
        }
    }
    
    private func updateBreatheActionAndAnimation(duration: Double) {
        if timerCount >= duration {
            timerCount = 0
            switch currentType.color {
                case lightPinkColor, lightPurpleColor:
                    breatheAction = (breatheAction == "Breathe In" ? "Breathe Out" : "Breathe In")
                case lightBlueColor:
                    breatheAction = (breatheAction == "Breathe Out" ? "Breathe In" : "Breathe Out")
                default:
                    break
            }
            withAnimation(.easeInOut(duration: duration).delay(0.1)){
                startAnimation.toggle()
            }
            UIImpactFeedbackGenerator(style: .heavy).impactOccurred()
        } else {
            timerCount += 0.01
            count = Int(duration - timerCount) + 1
        }
    }
    
    @ViewBuilder
    private func Content() -> some View {
        VStack {
            HStack {
                Text("Breath")
                    .font(.largeTitle)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.top, -50)
            }
            .padding()
            .opacity(showBreatheView ? 0 : 1)
            GeometryReader { proxy in
                VStack {
                    BreatheView(size: proxy.size)
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 12) {
                            ForEach(sampleTypes) { type in
                                Text(type.title)
                                    .foregroundColor(currentType.id == type.id ? .black : .black)
                                    .font(Font.system(size: currentType.id == type.id ? 20 : 17).bold())
                                    .padding(.vertical, 10)
                                    .padding(.horizontal, 15)
                                    .contentShape(Rectangle())
                                    .onTapGesture {
                                        withAnimation(.easeInOut){
                                            currentType = type
                                        }
                                    }
                            }
                        }
                        .padding()
                        .padding(.leading, 25)
                    }
                    .opacity(showBreatheView ? 0 : 1)
                    Button(action: startBreathing) {
                        Text(showBreatheView ? "FINISH BREATH" : "START")
                            .fontWeight(.semibold)
                            .foregroundColor(showBreatheView ? .black.opacity(0.75) : .black)
                            .padding(.vertical, 15)
                            .frame(maxWidth: .infinity)
                            .background(RoundedRectangle(cornerRadius: 12, style: .continuous).fill(currentType.color.gradient))
                    }
                    .padding()
                }
                .frame(width: proxy.size.width, height: proxy.size.height, alignment: .bottom)
            }
        }
        .frame(maxHeight: .infinity, alignment: .top)
    }
    
    @ViewBuilder
    private func BreatheView(size: CGSize) -> some View {
        ZStack {
            if currentType.color == lightPinkColor {
                ForEach(1...8, id: \.self) { index in
                    Circle()
                        .fill(currentType.color.gradient.opacity(0.5))
                        .frame(width: 150, height: 150)
                        .offset(x: startAnimation ? 0 : 75)
                        .rotationEffect(.degrees(Double(index) * 45))
                        .rotationEffect(.degrees(startAnimation ? -45 : 0))
                        .scaleEffect(startAnimation ? 0.6 : 1)
                }
            } else if currentType.color == lightPurpleColor {
                ForEach(0...3, id: \.self) { circleSetNumber in
                    ZStack {
                        if circleSetNumber == 1 {
                            Circle()
                                .fill(LinearGradient(gradient: Gradient(colors: [.purple, .pink]), startPoint: .top, endPoint: .bottom))
                                .frame(width: startAnimation ? 150 : 100, height: startAnimation ? 100 : 150)
                        }
                        Circle()
                            .fill(LinearGradient(gradient: Gradient(colors: [.purple, .pink]), startPoint: .top, endPoint: .bottom))
                            .frame(width: startAnimation ? 150 : 100, height: startAnimation ? 100 : 150)
                            .offset(y: startAnimation ? 0 : 75)

                        Circle()
                            .fill(LinearGradient(gradient: Gradient(colors: [.pink, .purple]), startPoint: .bottom, endPoint: .top))
                            .frame(width: startAnimation ? 100 : 150, height: startAnimation ? 150 : 100)
                            .offset(y: startAnimation ? 0 : -75)
                    }
                    .opacity(0.7)
                    .rotationEffect(.degrees(Double(circleSetNumber * 60)))
                }
            } else if currentType.color == lightBlueColor {
                ForEach(0...2, id: \.self) { circleSetNumber in
                    ZStack {
                        Circle().fill(LinearGradient(gradient: Gradient(colors: [.blue, .blue]), startPoint: .bottom, endPoint: .top))
                            .frame(width: 150, height: 150)
                            .offset(y: startAnimation ? 75 : 0)
                        
                        Circle().fill(LinearGradient(gradient: Gradient(colors: [.blue, .blue]), startPoint: .top, endPoint: .bottom))
                            .frame(width: 150, height: 150)
                            .offset(y: startAnimation ? -75 : 0)
                    }
                    .opacity(0.5)
                    .rotationEffect(.degrees(startAnimation ? Double(circleSetNumber * 60) : 0))
                    .scaleEffect(startAnimation ? 1 : 0.4)
                }
            }
        }
        .frame(height: size.width - 40)
        .overlay(content: {
            Text("\(count == 0 ? 1 : count)")
                .font(.title)
                .fontWeight(.semibold)
                .foregroundColor(.white)
                .animation(.easeInOut, value: count)
                .opacity(showBreatheView ? 1 : 0)
        })
    }
    
    private func startBreathing() {
        withAnimation(.interactiveSpring(response: 0.6, dampingFraction: 0.7, blendDuration: 0.7)){
            showBreatheView.toggle()
        }
        if showBreatheView {
            var duration: Double = 0
            switch currentType.color {
                case lightPinkColor: duration = 4
                case lightPurpleColor: duration = 7
                case lightBlueColor: duration = 3
                default: duration = 0
            }
            withAnimation(.easeInOut(duration: duration).delay(0.05)){
                startAnimation = true
            }
        } else {
            withAnimation(.easeInOut(duration: 1.5)){
                startAnimation = false
            }
        }
    }
    
    private func Background() -> some View {
        GeometryReader { proxy in
            let size = proxy.size
            ZStack{
                Rectangle()
                    .fill(.linearGradient(colors: [currentType.color.opacity(0.9), .clear, .clear], startPoint: .top, endPoint: .bottom))
                    .frame(height: size.height / 0.80)
                    .frame(maxHeight: .infinity, alignment: .top)
                
                Rectangle()
                    .fill(.linearGradient(colors: [.clear, .white, .white, .white, .white], startPoint: .top, endPoint: .bottom))
                    .frame(height: size.height / 1.5)
                    .frame(maxHeight: .infinity, alignment: .bottom)
            }
        }
        .ignoresSafeArea()
    }
}

#Preview {
    BreathView()
}

//dalsie animacie:
//ForEach((0...6), id: \.self) {circleSetNumber in
//    else if currentType.color == lightBlueColor {
//        ForEach((0...6), id: \.self) { circleSetNumber in
//            ZStack {
//                Circle().fill(LinearGradient(gradient: Gradient(colors: [.blue, .white]), startPoint: .bottom, endPoint: .top))
//                    .frame(width: startAnimation ? 150 : 100, height: startAnimation ? 150 : 100)
//                    .offset(y: startAnimation ? 75 : 0)
//
//                Circle().fill(LinearGradient(gradient: Gradient(colors: [.blue, .white]), startPoint: .top, endPoint: .bottom))
//                    .frame(width: startAnimation ? 150 : 100, height: startAnimation ? 150 : 100)
//                    .offset(y: startAnimation ? -75 : 0)
//            }
//            .opacity(0.5)
//            .rotationEffect(.degrees(startAnimation ? Double(circleSetNumber*60) : 0))
//            .scaleEffect(startAnimation ? CGFloat(7 - circleSetNumber) / 5 : 0.4) // Zväčšujte až do 1, potom zmenšujte
//        }
//    }
    
//ForEach((0...2), id: \.self) {circleSetNumber in
//                    ZStack {
//                        Circle().fill(LinearGradient(gradient: Gradient(colors: [.blue, .white]), startPoint: .bottom, endPoint: .top))
//                            .frame(width: 150, height: 150)
//                            .offset(y: startAnimation ? 75 : 0)
//
//                        Circle().fill(LinearGradient(gradient: Gradient(colors: [.blue, .white]), startPoint: .top, endPoint: .bottom))
//                            .frame(width: 150, height: 150)
//                            .offset(y: startAnimation ? -75 : 0)
//                    }
//                    .opacity(0.5)
//                    .rotationEffect(.degrees(startAnimation ? Double(circleSetNumber*60) : 0))
//                    .scaleEffect(startAnimation ? 1 : 0.4)
//                }
                
//                ForEach((0...6), id: \.self) { circleSetNumber in
//                    ZStack {
//                        Circle().fill(LinearGradient(gradient: Gradient(colors: [.blue, .white]), startPoint: .bottom, endPoint: .top))
//                            .frame(width: startAnimation ? 150 : 100, height: startAnimation ? 150 : 100)
//                            .offset(y: startAnimation ? 75 : 0)
//
//                        Circle().fill(LinearGradient(gradient: Gradient(colors: [.blue, .white]), startPoint: .top, endPoint: .bottom))
//                            .frame(width: startAnimation ? 150 : 100, height: startAnimation ? 150 : 100)
//                            .offset(y: startAnimation ? -75 : 0)
//                    }
//                    .opacity(0.5)
//                    .rotationEffect(.degrees(startAnimation ? Double(circleSetNumber*60) : 0))
//                    .scaleEffect(startAnimation ? 1 : 0.4)
//                }


//Nadýchanie a vydýchanie môže ovplyvňovať vaše emócie a naopak, emócie môžu ovplyvňovať váš dych. Tu sú odhady na základe bežných skúseností:
//
//Keď sme šťastní: Pri šťastných pocitoch sa obvykle nadýchame a vydýchneme plynule a rytmicky. Odporúčaný rytmus je asi 4 sekundy na nádych a 4 sekundy na výdych.
//
//Keď sme smutní: Smútok môže spôsobiť plytvanie dychu alebo hlboké vzdychy. Pri hlbokom smútku sa nádychy a výdychy môžu predlžiť, napríklad nádych môže trvať asi 6-8 sekúnd a výdych rovnaký alebo trochu dlhší.
//
//Keď sme nahnevaní: Keď sme nahnevaní, dych sa často stáva plytkým a rýchlym. Môže to byť krátke, plytké dýchanie, ktoré sa deje veľmi rýchlo, napríklad 2 sekundy na nádych a 2 sekundy na výdych.
//
//Tieto sú len všeobecné odhady a môžu sa líšiť v závislosti od jednotlivca a kontextu. Dôležité je uvedomiť si, že uvedomené dýchanie môže mať pozitívny vplyv na vaše emócie a celkový stav mysle.
