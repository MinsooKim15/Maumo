//
//  HomeView.swift
//  Maumo
//
//  Created by minsoo kim on 2021/02/01.
//

import SwiftUI
struct OldHomeView: View{
    
    @ObservedObject var modelView: HomeModelView
    @ObservedObject var journalView = MaumJournalModelView()
    @EnvironmentObject var session:SessionStore
    @State var willMoveToChatView:Bool = false
    @State var willMoveToSettingView:Bool = false
    
//    func setUserId(){
//        if let userIdString =  self.session.session?.uid{
//            print(userIdString)
//            self.modelView.setUserId(userIdString)
//        }
//    }
    var settingButtonMarginToTop: CGFloat{
        if UIDevice.current.userInterfaceIdiom == .pad {
            return CGFloat(400)
        } else {
            return CGFloat(40)
        }
    }
    var startChatButtonMarginTopToSettingButton: CGFloat{
        if UIDevice.current.userInterfaceIdiom == .pad {
            return CGFloat(360)
        } else {
            return CGFloat(200)
        }
    }
    
    var body : some View{
        GeometryReader{ geometry in
            NavigationView{
                ZStack{

                    // MARK: - 배경
                    Group{
                        Image("HomeBackground")
                                .resizable()
                                .scaledToFill()
                                .edgesIgnoringSafeArea(.all)
                    }
                    VStack{
                        HStack{
                            Spacer()
                            ZStack{
                                Color.red
                                SettingButton(action: {self.willMoveToSettingView = true})
                            }.frame(width:50, height:50)
                            Spacer().frame(width:20)
                        }.padding([.top],self.settingButtonMarginToTop)
                        HStack{
                            startChatButton()
                                .onTapGesture {
                                    self.willMoveToChatView = true
                                }
                                .padding([.leading],40)
                            Spacer()
                        }
                        .frame(height:44)
                        .padding([.top],140)
                        Spacer()
                        MaumJournalSummaryView(modelView:MaumJournalModelView())
                        Spacer().frame(height:20)
                        // MARK: - Navigation 모음
                        Group{
                            NavigationLink(
                                destination: SettingView(modelView:SettingModelView())                            .navigationBarTitle("")
                                    .navigationBarHidden(true),
                                isActive: $willMoveToSettingView
                            ) {
                                EmptyView()
                            }
        //                    MARK:- 14.5.1에서 계속 튕기는 현상을 막기 위한 임시 처리임.
                            NavigationLink(destination: EmptyView(), label: {})
                            NavigationLink(
                                destination: ChatView(modelView: ChattingModelView(userId:self.session.session?.uid))                         .navigationBarTitle("")
                                    .navigationBarHidden(true),
                                isActive: $willMoveToChatView
                            ) {
                                EmptyView()
                            }
                        }
                    }
                }
            }
            .navigationViewStyle(StackNavigationViewStyle())
        }
            .onAppear{
                self.modelView.callTransparencyPopupIfNeeded()
            }
        
    }
}
struct SettingButton:View{
    var action : ()->Void
    var body: some View{
            Button(action: {action()}, label: {
                Group{
                    ZStack{
                        Circle()
                            .frame(width:48, height:48)
                            .foregroundColor(.white)
                        Image(systemName: "ellipsis")
                            .font(.system(size: 20))
                            .foregroundColor(.black)
                    }
                    .frame(width:80, height:80)
                    .shadow(radius: 5)
                }
            }).frame(width:50, height:50)
    }
}
struct startChatButton:View{
    @EnvironmentObject var session:SessionStore
    var helloText : String{
        return "안녕! " + (self.session.session?.name?.full ?? "")
    }
    let textFontSetting = FontSetting(fontWeight: .bold, fontSize: .medium20)
    let helloTextFontSetting = FontSetting(fontWeight: .regular, fontSize: .small14)
    var body: some View{
        VStack(alignment: .leading){
            Text(self.helloText)
                .adjustFont(fontSetting: helloTextFontSetting)
                .foregroundColor(.navy)
            Text("대화하기")
                .adjustFont(fontSetting: textFontSetting)
                .foregroundColor(.navy)
            Image(systemName: "arrow.right")
                .font(.system(size: 40))
                .foregroundColor(.salmon)
                .padding([.leading],36)
        }
    }
}
//struct SettingButton_Previews: PreviewProvider {
//    static var previews: some View {
//        HomeView(modelView: MainModelView()).environmentObject(SessionStore())
//    }
//}
