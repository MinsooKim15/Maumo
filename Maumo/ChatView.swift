//
//  ChatView.swift
//  Maumo
//
//  Created by minsoo kim on 2021/01/31.
//

import SwiftUI
struct ChatView:View{
    @ObservedObject var modelView: MainModelView
    @State var typingMessage : String = "입력"
    func sendMessage(){
        modelView.send(text:typingMessage)
    }
    func sendEventMessage(){
        modelView.send(eventName:"actions_intent_WELCOME")
    }
    var computedView:some View{
        return Group{
            if !self.modelView.timerIsActive{
                HStack {
                    TextField("Message...", text: $typingMessage)
                       .textFieldStyle(RoundedBorderTextFieldStyle())
                       .frame(minHeight: CGFloat(30))
                     Button(action: sendMessage) {
                         Text("Send")
                      }
                 }.frame(minHeight: CGFloat(50)).padding()
            }
        }
        
    }
    var body: some View{
        VStack {
            Text("Welcome 이벤트").onTapGesture {
                sendEventMessage()
            }
           List {
            ForEach(modelView.chattingModel.messages) { msg in
                MessageView(currentMessage: msg, modelView:modelView)
                }
           }
            Group{
                computedView
            }
        }
    }
}
