//
//  ContentView.swift
//  Maumo
//
//  Created by minsoo kim on 2021/01/31.
//

import SwiftUI
import Firebase

struct ContentView: View {
    @EnvironmentObject var session:SessionStore
    @State var showScreen:Bool = false
    @State var showStart:Bool = false
    func getUserSession(){
        session.listen(){
            if self.session.session != nil, !(self.session.session?.isAnonymous ?? true){
                self.showScreen = true
            }else{
                self.showScreen = true
                self.showStart = true
            }
        }
    }
    var body: some View {
        VStack{
            Group{
                if self.session.session == nil {
                    WaitingView()
                }
                if self.session.session?.isAnonymous == true{
                    StartView()
                }
                if self.session.session?.isAnonymous == false{
                    HomeView(modelView: HomeModelView())
                }
            }
            EmptyView()
        }
        .onAppear(perform: {
            getUserSession()
        })
    }
}

