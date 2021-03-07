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
    //MARK:-이거 사용은 다시 고민해봅시다. 단일한 Event로 처리할 수 있을듯
    func sendEventMessage(){
        modelView.send(eventName:"actions_intent_WELCOME")
    }
    func userCameback(){
        modelView.userCameback()
    }
    var body: some View{
        ZStack{
            VStack {
                ScrollViewReader{value in
                    ScrollView{
                        LazyVStack(alignment: .leading){
                            Spacer().frame(height:50)
                            ForEach(modelView.chattingModel.messages) { msg in
                                MessageView(currentMessage: msg,isDifferentBefore: self.modelView.isDifferentBefore(message: msg), modelView:modelView).id(msg)
                            }
                        }
                        .padding([.leading],20)
                        .padding([.trailing],12)
                    }

                    .onChange(of: modelView.chattingModel.messages.count){ count in
                        if modelView.chattingModel.messages.count > 0{
                            withAnimation{value.scrollTo(modelView.chattingModel.messages[modelView.chattingModel.messages.count - 1 ])}
                        }

                    }
                    .onAppear{
                        if modelView.chattingModel.messages.count > 0{
                            withAnimation{value.scrollTo(modelView.chattingModel.messages[modelView.chattingModel.messages.count - 1 ])}
                        }
                        self.userCameback()
                    }
                }
                Spacer().frame(maxHeight:8)
                ChattingTextField(modelView: self.modelView)
                Spacer().frame(maxHeight:8)
            }
            VStack{
                CustomNavigationBar(hasTitleText: true, titleText: "대화")
                Spacer()
            }

        }.onTapGesture {
            hideKeyboard()
        }

        
    }
}
struct ChattingTextField:View{
    @ObservedObject var modelView : MainModelView
    @State var typingMessage : String = ""
    var buttonActive: Bool{
        return !(typingMessage == "")
    }
    func sendMessage(){
        modelView.send(text:typingMessage)
        self.typingMessage = ""
        hideKeyboard()
    }
    func sendButtonTapped(){
        if self.buttonActive{
            sendMessage()
        }
    }
    var computedTextField: some View{
        return Group{
            VStack{
                if !self.modelView.timerIsActive{
                    TextField("입력", text: $typingMessage).padding([.leading],8)
                }
                if self.modelView.timerIsActive{
                    Text("지금은 사용할 수 없어요.")
                }
            }
        }
    }
    var body: some View{
            HStack{
                Group{
                    ZStack{
                        RoundedRectangle(cornerRadius: 10).foregroundColor(.whiteGray)
                        computedTextField
                    }
                    .frame(height:36)

                    SendChatButton(isActive: buttonActive)
                        .onTapGesture {
                            sendButtonTapped()
                        }
                }.padding([.leading,.trailing],16)
            }
        .frame(height:36)
    }
}
struct SendChatButton: View{
    var isActive : Bool
    var backgroundColor: Color{
        if isActive{
            return .salmon
        }else{
            return .whiteGray
        }
    }
    var foregroundColor: Color{
        return .white
    }
    var body : some View{
        ZStack{
            Circle()
                .foregroundColor(backgroundColor)
            Image(systemName: "paperplane")
                .foregroundColor(foregroundColor)
        }.frame(width:32, height:32)
    }
}
struct ChatView_Previews: PreviewProvider {
    static var previews: some View {
        ChatView(modelView: MainModelView())
    }
}
