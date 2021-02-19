//
//  ChatView.swift
//  Maumo
//
//  Created by minsoo kim on 2021/01/31.
//

import SwiftUI
struct ChatView:View{
    init(modelView:MainModelView) {
        self.modelView = modelView
        if #available(iOS 14.0, *) {
            // iOS 14 doesn't have extra separators below the list by default.
        } else {
            // To remove only extra separators below the list:
            
        }
        UITableView.appearance().tableFooterView = UIView()
        // To remove all separators including the actual ones:
        UITableView.appearance().separatorStyle = .none
    }
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
        ZStack{
            VStack {
                ScrollView{
                    ScrollViewReader{value in
                        LazyVStack(alignment: .leading){
                            ForEach(modelView.chattingModel.messages) { msg in
                                MessageView(currentMessage: msg,isDifferentBefore: self.modelView.isDifferentBefore(message: msg), modelView:modelView)
                            }
                            
                        }
                        .onAppear{
                            value.scrollTo(modelView.chattingModel.messages.count)
                        }
                        .padding([.leading],20)
                        .padding([.trailing],12)
                    }
                }
                Group{
                    computedView
                }
            }
            VStack{
                CustomNavigationBar(hasTitleText: false, titleText: "")
                Spacer()
            }

        }

        
    }
}
struct ChatView_Previews: PreviewProvider {
    static var previews: some View {
        ChatView(modelView: MainModelView())
    }
}
