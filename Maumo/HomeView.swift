//
//  HomeView.swift
//  Maumo
//
//  Created by minsoo kim on 2021/02/01.
//

import SwiftUI
struct HomeView: View{
    
    @ObservedObject var modelView: MainModelView
    
    var body : some View{
        NavigationView(){
//            ZStack{
//                Text("채팅 시작")
                NavigationLink(destination: ChatView(modelView:self.modelView)){
//                    EmptyView()
                    Text("채팅 시작")
                    }
//            }

        }
    }
}
