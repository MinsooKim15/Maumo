//
//  NewHomeView.swift
//  Maumo
//
//  Created by minsoo kim on 2021/06/27.
//

import SwiftUI

struct HomeView: View {
    @ObservedObject var modelView: HomeModelView
    @EnvironmentObject var session:SessionStore
    @State var willMoveToSettingView = false
    @State var willMoveToChatView = false
    var body: some View {
        NavigationView{
            ZStack{
//              Mark : - 배경
                Group{
                    Image("HomeBackground")
                            .resizable()
                            .scaledToFill()
                            .edgesIgnoringSafeArea(.all)
                }
                VStack{
                    Spacer().frame(height:40)
                    HStack{
                        Spacer()
                        SettingButton(action: {self.willMoveToSettingView = true}).padding([.trailing],20)
                    }.padding([.top],20)
                    Spacer()
                    HStack{
                        startChatButton()
                            .padding([.leading],60)
                            .onTapGesture {self.willMoveToChatView = true}
                        Spacer()
                    }
                    Spacer().frame(height:80)
                    MaumJournalSummaryView(modelView: MaumJournalModelView()).padding([.bottom],120)
                    Group{
                        NavigationLink(
                            destination: SettingView(modelView:SettingModelView())                            .navigationBarTitle("")
                                .navigationBarHidden(true),
                            isActive: $willMoveToSettingView
                        ) {
                            EmptyView()
                        }
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
            
        }.navigationViewStyle(StackNavigationViewStyle())
        .onAppear{
            self.modelView.callTransparencyPopupIfNeeded()
        }
        .dragToDismiss()

    }
}

//struct HomeView_Previews: PreviewProvider {
//    static var previews: some View {
//        NewHomeView().environmentObject(SessionStore())
//    }
//}
