//
//  StartView.swift
//  Maumo
//
//  Created by minsoo kim on 2021/04/25.
//

import SwiftUI
struct StartView:View{
    let startStringTextSetting = FontSetting(fontWeight: .bold, fontSize: .medium20)
    let signUpTextSetting = FontSetting(fontWeight: .light, fontSize: .small14)
//    @ObservedObject var modelView: ChattingModelView
    @State var willNavigateToSignInView = false
    @State var willNavigateToTutorialView = false
    @EnvironmentObject var session:SessionStore
    var body : some View{
        GeometryReader{ geometry in
            NavigationView{
                ZStack{
                    Image("HomeBackground")
                            .resizable()
                            .scaledToFill()
                            .edgesIgnoringSafeArea(.all)
                    VStack{
                        HStack{
                            Spacer().frame(width:20)
                            VStack{
                                HStack{
                                    Text("시작하기")
                                        .adjustFont(fontSetting: self.startStringTextSetting)
                                        .onTapGesture {
                                            self.willNavigateToTutorialView = true
                                        }.padding([.leading],20)
                                    Image(systemName: "arrow.right")
                                        .font(.system(size: 40))
                                        .foregroundColor(.salmon)
                                        .padding([.leading],10)
                                }

                                Text("기존 회원 로그인하기").adjustFont(fontSetting: self.signUpTextSetting)
                                    .onTapGesture {
                                        self.willNavigateToSignInView = true
                                    }
                            }
                            Spacer()
                        }
                        NavigationLink(destination: SignInView()
                                        .navigationBarTitle("")
                                        .navigationBarHidden(true),
                                       isActive:$willNavigateToSignInView){
                            EmptyView().frame(width:0, height:0)
                        }
                        NavigationLink(destination: TutorialView(modelView: ChattingModelView(userId:self.session.session?.uid, isTutorial:true))                                .navigationBarTitle("")
                                        .navigationBarHidden(true)
                                       ,isActive:$willNavigateToTutorialView){
                            EmptyView().frame(width:0, height:0)
                        }
                    }
            }
            }.onAppear{
                session.signInAnonymous()

            }
            .navigationViewStyle(StackNavigationViewStyle())
    }
    }
}
//struct StartView_Previews: PreviewProvider {
//    static var previews: some View {
//        StartView(modelView:ChattingModelView())
//    }
//}
