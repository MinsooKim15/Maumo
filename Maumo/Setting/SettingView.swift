//
//  SettingView.swift
//  Maumo
//
//  Created by minsoo kim on 2021/02/21.
//

import SwiftUI

struct SettingView: View {
    
    var modelView : SettingModelView
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    let navBarPaddingToLead = CGFloat(20)
    let navBarPaddingToTop = CGFloat(20)
    let navBarMaxHeight = CGFloat(50)
    let spaceBetweenUserViewAndSettingList = CGFloat(4)
    let spaceBetweenUserViewAndHomeKey = CGFloat(4)
    let spaceBetweenHomeKeyAndSettingList = CGFloat(4)
    @EnvironmentObject var session : SessionStore
    func signOut(){
        self.session.signOut()
    }
    var body: some View {
        ZStack{
            Color.beigeWhite
            VStack{
                CustomNavigationBar(hasTitleText: true, titleText: "설정",backgroundColor:Color.beigeWhite)
                HStack{
                    Text("로그아웃").padding([.leading],16)
                    Spacer()
                }

                .onTapGesture{
                    self.signOut()
                }
                    .padding([.top],20)
                .frame(height:40)
                Divider()
                Spacer()
                }
                }
                .navigationBarTitle("")
                .navigationBarHidden(true)
        }
}
