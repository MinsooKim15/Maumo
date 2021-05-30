//
//  MaumoApp.swift
//  Maumo
//
//  Created by minsoo kim on 2021/01/31.
//

import SwiftUI
import Firebase
@main
struct MaumoApp: App {
    @StateObject var session: SessionStore = SessionStore()
    init() {
        FirebaseApp.configure()
      }
    var body: some Scene {
        WindowGroup {
            ContentView(modelView:ChattingModelView()).environmentObject(session)
        }
    }
}
