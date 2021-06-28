//
//  ChatView.swift
//  Maumo
//
//  Created by minsoo kim on 2021/01/31.
//

import SwiftUI
struct ChatView:View{
    init(modelView:ChattingModelView) {
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
    @EnvironmentObject var session:SessionStore
    @ObservedObject var modelView: ChattingModelView
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
    func setUserId(){
        print("setUserId")
        if let userIdString =  self.session.session?.uid{
            print(userIdString)
            self.modelView.setUserId(userIdString)
        }
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
                        self.setUserId()
                    }
                }
                Spacer().frame(maxHeight:8)
                ChattingInputField(modelView:self.modelView)
//                ChattingTextField(modelView: self.modelView)
                Spacer().frame(maxHeight:8)
            }
            VStack{
                CustomNavigationBar(hasTitleText: true, titleText: "대화")
                Spacer()
            }
            NavigationLink(
                destination: StartVerticalServiceView(modelView: self.modelView).navigationBarTitle("").navigationBarHidden(true),
                isActive: self.$modelView.chattingModel.showVerticalServiceView,
                label: {
                    EmptyView()
                })
        }
        .dragToDismiss()
        .onTapGesture {
            hideKeyboard()
            print("개수 : \(self.modelView.chattingModel.messages.count)")
            print(self.modelView.chattingModel.messages)
        }
        
        

        
    }
}
struct ChattingInputField:View{
    // TODO: ChattingModel의 상태값을 기준으로 입력을 정의한다.
    @ObservedObject var modelView : ChattingModelView
    func computedView() -> AnyView{
        switch(self.modelView.chattingModel.chattingStatus){
        case .idle:
            return AnyView(ChattingTextField(modelView: self.modelView))
        case .thinking:
            return AnyView(EmptyView())
        case .textEditing:
            return AnyView(ChattingTextField(modelView: self.modelView))
        case .replying:
            if let replyType = self.modelView.getCurrentReplyType(){
                switch(replyType){
                case .quickReply:
                    return AnyView(QuickReplyMessageView(message: self.modelView.getCurrentReplyMessage()!, modelView: self.modelView))
//                case .simpleInform:
//                    // 하지만 simpleInform이 Replying으로 떨어지면 에러임.
//                    return AnyView(EmptyView())
//                case .timer:
//                    return AnyView(EmptyView())
                default:
                    return AnyView(EmptyView())
                }
            }
            return AnyView(ChattingTextField(modelView: self.modelView))
        }
    }
    var body : some View{
        computedView().transition(.opacity)
    }
}
struct ChattingTextField:View{
    @ObservedObject var modelView : ChattingModelView
    @State var typingMessage : String = ""{
        didSet{
            if typingMessage == ""{
                self.modelView.stopTextEditing()
            }else{
                self.modelView.startTextEditing()
            }
        }
    }
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
    var textFieldColor : Color{
        if !self.modelView.timerIsActive{
            return Color.whiteGray
        }else{
            return Color.whiteGray
        }
    }
    var body: some View{
            HStack{
                Group{
                    ZStack{
                        RoundedRectangle(cornerRadius: 10).foregroundColor(self.textFieldColor)
                        TextField("입력", text: $typingMessage).padding([.leading],8)
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
//struct ChatView_Previews: PreviewProvider {
//    static var previews: some View {
//        ChatView(modelView: ChattingModelView())
//    }
//}
