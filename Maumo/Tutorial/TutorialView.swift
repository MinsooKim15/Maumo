//
//  TutorialView.swift
//  Maumo
//
//  Created by minsoo kim on 2021/04/25.
//

import SwiftUI
struct TutorialView:View{
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
    @State var showSignUp: Bool = false
    func sendMessage(){
        modelView.send(text:typingMessage)
    }
    //MARK:-이거 사용은 다시 고민해봅시다. 단일한 Event로 처리할 수 있을듯

    func userTutorialStart(){
        modelView.startTutorial()
    }
    var body: some View{
        GeometryReader{_ in
            ZStack{
                VStack {
                    CustomNavigationBar(hasTitleText: true, titleText: "대화")
                    Spacer()
                    ScrollViewReader{value in
                        ScrollView{
                            LazyVStack(alignment: .leading){
                                Spacer().frame(height:50)
                                ForEach(modelView.chattingModel.messages) { msg in
                                    MessageView(currentMessage: msg,isDifferentBefore: self.modelView.isDifferentBefore(message: msg), modelView:modelView).id(msg)
                                }
                                if self.modelView.chattingModel.currentReplyType == .signUp{
                                    HStack{
                                        Spacer().frame(width: 44, height: 37, alignment: .center)
                                        MessageButtonView(buttonAction: {self.showSignUp.toggle()}, buttonMessage: "이름 소개하기")
                                    }
                                    
                                }
                            }
                            .padding([.leading],20)
                            .padding([.trailing],12)
                        }.transition(AnyTransition.scale)

                        .onChange(of: modelView.chattingModel.messages.count){ count in
                            if modelView.chattingModel.messages.count > 0{
                                withAnimation{value.scrollTo(modelView.chattingModel.messages[modelView.chattingModel.messages.count - 1 ])}
                            }

                        }
                        .onAppear{
                            if modelView.chattingModel.messages.count > 0{
                                withAnimation{value.scrollTo(modelView.chattingModel.messages[modelView.chattingModel.messages.count - 1 ])}
                            }
                            self.userTutorialStart()
                        }
                        
                    }
                    Spacer().frame(maxHeight:8)
                    ChattingInputField(modelView:self.modelView)
                    Spacer().frame(maxHeight:8)
                }
                Group{
                    if self.showSignUp{
                        Color.black.opacity(0.5).ignoresSafeArea(.all, edges: .all)
                        SignUpSmallView(signUpSuccessClousure: self.modelView.signUpSuccessCompletion)
                            .frame(width: 340, height : 640)
                            .clipShape(RoundedRectangle(cornerRadius: 10.0))
                    }
                }
            }
        }
        .onTapGesture {
            hideKeyboard()
        }
        
    }
}
