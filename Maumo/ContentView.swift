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
            if let userIdString = self.session.session?.uid{
                self.modelView.setUserId(userIdString)
            }
        }
    }
    
    var body: some View {
        VStack{
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
        }
        .onAppear(perform: {
            getUserSession()
        })
    }
}

