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
    @State var willShowImageRightView :Bool = false
    @State var willShowPurchaseListView :Bool = false
    
    func signOut(){
        self.session.signOut()
    }
    var body: some View {
        ZStack{
            Group{
//                Navigation Stuff
                NavigationLink(
                    destination: PurchaseListView(),
                    isActive: $willShowPurchaseListView,
                    label: {
                        EmptyView()
                    })
            NavigationLink(
                destination: PurchaseListView(),
                isActive: $willShowPurchaseListView,
                label: {
                    EmptyView()
                })
            NavigationLink(
                destination: ImageRightView(),
                isActive: $willShowImageRightView,
                label: {
                    EmptyView()
                })
            }
            
            
            Color.beigeWhite.ignoresSafeArea(.all)
            VStack{
                CustomNavigationBar(hasTitleText: true, titleText: "설정",backgroundColor:Color.beigeWhite)
                Group{
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
                }
                Group{
                    HStack{
                        Text("이미지 사용권").padding([.leading],16)
                        Spacer()
                    }
                    .onTapGesture{
                        self.willShowImageRightView = true
                    }
                        .padding([.top],20)
                    .frame(height:40)
                    Divider()
                }
                Group{
                    HStack{
                        Text("서비스 구매 내역").padding([.leading],16)
                        Spacer()
                    }
                    .onTapGesture{
                        self.willShowPurchaseListView = true
                    }
                    .padding([.top],20)
                    .frame(height:40)
                    Divider()
                }
                Spacer()
                }
                }
        .dragToDismiss()
                .navigationBarTitle("")
                .navigationBarHidden(true)
        
    }
}
