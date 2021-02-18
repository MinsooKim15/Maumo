//
//  ContentView.swift
//  Maumo
//
//  Created by minsoo kim on 2021/01/31.
//

import SwiftUI
import Firebase

struct ContentView: View {
    @ObservedObject var modelView: MainModelView
    @EnvironmentObject var session:SessionStore
    
    func touched(){
        print(modelView.chattingModel.messages)
    }
    func getUserSession(){
        session.listen(){
            print("done")
        }
    }
    func signOutTemp(){
        self.session.signOut()
    }
    var body: some View {
        VStack{
//            Text("로그 아웃").onTapGesture {
//                signOutTemp()
//            }
            Group{
                if session.session != nil {
                    HomeView(modelView:self.modelView)
                }
            }
            Group{
                if session.session == nil {
                    SignUpView()
                }
            }
            EmptyView()
        }.onAppear(perform: {
            getUserSession()
        })
//        Group{
//            if session.session != nil {
//                HomeView(modelView:self.modelView)
//            }
            
//            if !(session.session){
//                SignUpView()
//            }
//            if (session.session){
//                HomeView(modelView:self.modelView)
//            }
//        }

    }
}

