//
//  HomeView.swift
//  Maumo
//
//  Created by minsoo kim on 2021/02/01.
//

import SwiftUI
struct HomeView: View{
    
    @ObservedObject var modelView: MainModelView
    @EnvironmentObject var session:SessionStore
    @State var willMoveToChatView:Bool = false
    let textFontSetting = FontSetting(fontWeight: .bold, fontSize: .medium20)
    var body : some View{
            ZStack{
                    Image("HomeBackground")
                        .resizable()
                        .scaledToFill()
                        .edgesIgnoringSafeArea(.all)
                VStack{
                    HStack{
                        Spacer()
                        SettingButton()
                            .padding([.trailing],30)
                            .padding([.top],60)
                    }
                    Spacer().frame(height:280)
                    HStack{
                        VStack{
                            Text("대화하기")
                                .adjustFont(fontSetting: textFontSetting)
                                .foregroundColor(.navy)
        //                                .padding([.leading],24)
                            Image(systemName: "arrow.right")
                                .font(.system(size: 40))
                                .foregroundColor(.salmon)
                                .padding([.leading],36)
                        }
                        .onTapGesture {
                            self.willMoveToChatView = true
                        }
                        .padding([.leading],40)
                        Spacer()
                    }
                    Spacer()
                }
            }
            .navigate(to: ChatView(modelView: modelView), when: $willMoveToChatView)
    }
}
struct SettingButton:View{
    var body: some View{
        ZStack{
            Circle().frame(width:48, height:48)
                .foregroundColor(.white)
            Image(systemName: "ellipsis")
                .font(.system(size: 20))
                .foregroundColor(.black)
        }
        .shadow(radius: 5)
        .padding([.top],20)
    }
}
struct SettingButton_Previews: PreviewProvider {
    static var previews: some View {
        HomeView(modelView: MainModelView())
    }
}
