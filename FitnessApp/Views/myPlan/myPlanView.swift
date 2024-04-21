import SwiftUI
import AVKit

struct myPlanView: View {
//    @State private var searchText: String = ""
//    @State private var isSearching = false
//
//    @State private var selectedFilter: String = ""
//    @State private var isFilterSelectionSheetPresented = false
    
    @State private var isDetail1Presented = false
    @State private var isDetail2Presented = false
    @State private var isDetail3Presented = false
    
    var body: some View {
        //NavigationView {
            ScrollView {
                VStack {
                    Text("My plan")
                        .font(.system(size: 25))
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .padding(.top, 75)
                        .frame(maxWidth: .infinity)
                        .frame(height: 130)
                        .background(Color.purple)
                        .padding(.top, -145)
                    
                    
//                    HStack(spacing: 30) {
//                        Text("BLOG")
//                            .foregroundColor(.black)
//                            .font(.system(size: 15, weight: .bold))
//                            .textCase(.uppercase)
//                        
//                        NavigationLink(destination: ShoppingListView(), label: {
//                            Text("SHOPPING LIST")
//                                .foregroundColor(.black)
//                                .font(.system(size: 15, weight: .bold))
//                                .textCase(.uppercase)
//                        })
//                        .transition(.slide)
//                        
//                        NavigationLink(destination: Diar(), label: {
//                            Text("DIARY")
//                                .foregroundColor(.black)
//                                .font(.system(size: 15, weight: .bold))
//                                .textCase(.uppercase)
//                        })
//                        .transition(.slide)
//                        
//                        NavigationLink(destination: Account(), label: {
//                            Text("ACCOUNT")
//                                .foregroundColor(.black)
//                                .font(.system(size: 15, weight: .bold))
//                                .textCase(.uppercase)
//                        })
//                        .transition(.slide)
//                    }
                    
                    HStack(spacing: 10) {
                        Text("BLOG")
                            .foregroundColor(.black)
                            .font(.system(size: 15, weight: .bold))
                            .textCase(.uppercase)
                            .padding(.vertical, 8)
                        
                        Divider()
                        
                        NavigationLink(destination: ShoppingListView()) {
                            Text("SHOPPING LIST")
                                .foregroundColor(.black)
                                .font(.system(size: 15, weight: .bold))
                                .textCase(.uppercase)
                                .padding(.vertical, 8)
                        }
                        .transition(.slide)
                        
                        Divider()
                        
                        NavigationLink(destination: Diar()) {
                            Text("DIARY")
                                .foregroundColor(.black)
                                .font(.system(size: 15, weight: .bold))
                                .textCase(.uppercase)
                                .padding(.vertical, 8)
                        }
                        .transition(.slide)
                        
                        Divider()
                        
                        NavigationLink(destination: Account()) {
                            Text("ACCOUNT")
                                .foregroundColor(.black)
                                .font(.system(size: 15, weight: .bold))
                                .textCase(.uppercase)
                                .padding(.vertical, 8)
                        }
                        .transition(.slide)
                    }
                    .padding(.horizontal, 20)
                    .background(Color.purple.opacity(0.2))
                    .padding(.top, -10)
                    
                    
                    NavigationView {
                        VStack {
                            Button(action: {
                                isDetail1Presented.toggle()
                            }) {
                                VStack {
                                    Image("meat1")
                                        .resizable()
                                        .frame(maxWidth: 370)
                                        .frame(height: 250)
                                        .padding(.top, -40)
                                    
                                    RoundedRectangle(cornerRadius: 0)
                                        .fill(Color.purple.opacity(0.2))
                                        .frame(maxWidth: 370)
                                        .frame(height: 70)
                                        .padding(.top, -8)
                                    
                                    Text("Meat")
                                        .foregroundColor(.black)
                                        .font(.headline)
                                        .padding(.top, -50)
                                }
                            }
                            .sheet(isPresented: $isDetail1Presented) {
                                Detail1()
                            }
                        }
                        
                    } .padding(.bottom, -50)
                    
                    NavigationView {
                        VStack {
                            Button(action: {
                                isDetail2Presented.toggle()
                            }) {
                                VStack {
                                    Image("protein")
                                        .resizable()
                                        .frame(maxWidth: 370)
                                        .frame(height: 250)
                                        .padding(.top, -100)
                                    
                                    RoundedRectangle(cornerRadius: 0)
                                        .fill(Color.purple.opacity(0.2))
                                        .frame(maxWidth: 370)
                                        .frame(height: 70)
                                        .padding(.top, -8)
                                    
                                    Text("Proteins")
                                    //Text("Proteins - not only for muscle")
                                        .foregroundColor(.black)
                                        .font(.headline)
                                        .padding(.top, -50)
                                }
                            }
                            .sheet(isPresented: $isDetail2Presented) {
                                Detail2()
                            }
                        }
                        
                    } .padding(.bottom, -80)
                    
                    NavigationView {
                        VStack {
                            Button(action: {
                                isDetail3Presented.toggle()
                            }) {
                                VStack {
                                    Image("thePower")
                                        .resizable()
                                        .frame(maxWidth: 370)
                                        .frame(height: 250)
                                        .padding(.top, -100)
                                    
                                    RoundedRectangle(cornerRadius: 0)
                                        .fill(Color.purple.opacity(0.2))
                                        .frame(maxWidth: 370)
                                        .frame(height: 70)
                                        .padding(.top, -8)
                                    
                                    Text("The power of silence")
                                        .foregroundColor(.black)
                                        .font(.headline)
                                        .padding(.top, -50)
                                }
                            }
                            .sheet(isPresented: $isDetail3Presented) {
                                Detail3()
                            }
                        }
                    }
    
            }
        }
    }
}





#Preview {
    myPlanView()
}



//    @State private var searchText: String = ""
//    @State private var isSearching = false
//
//    @State private var selectedFilter: String = ""
//    @State private var isFilterSelectionSheetPresented = false

//HStack(spacing: 30) {
//    Text("BLOG")
//        .foregroundColor(.black)
//        .font(.system(size: 15, weight: .bold))
//        .textCase(.uppercase)
//    
//    NavigationLink(destination: ShoppingListView(), label: {
//        Text("SHOPPING LIST")
//            .foregroundColor(.black)
//            .font(.system(size: 15, weight: .bold))
//            .textCase(.uppercase)
//    })
//    .transition(.slide)
//
//    NavigationLink(destination: Diar(), label: {
//        Text("DIARY")
//            .foregroundColor(.black)
//            .font(.system(size: 15, weight: .bold))
//            .textCase(.uppercase)
//    })
//    .transition(.slide)
//
//    NavigationLink(destination: Account(), label: {
//        Text("ACCOUNT")
//            .foregroundColor(.black)
//            .font(.system(size: 15, weight: .bold))
//            .textCase(.uppercase)
//    })
//    .transition(.slide)
//}

//VStack {
//    NavigationLink(destination: Detail1()) {
//        VStack {
//            Image("blog1")
//                .resizable()
//                .frame(maxWidth: 370)
//                .frame(height: 250)
//
//            RoundedRectangle(cornerRadius: 0)
//                .fill(Color.purple.opacity(0.2))
//                .frame(maxWidth: 370)
//                .frame(height: 70)
//                .padding(.top, -8)
//
//            Text("Comming soon...")
//                .foregroundColor(.black)
//                .font(.headline)
//                .padding(.top, -50)
//    }
//}
//}
