//
//  MainModelView.swift
//  Maumo
//
//  Created by minsoo kim on 2021/01/31.
//

import Foundation
import SwiftUI
import FirebaseCore
import FirebaseFirestore
import FirebaseFirestoreSwift
import Firebase
import AppTrackingTransparency


// TODO : ChangeName
class ChattingModelView:ObservableObject{
//    MARK: - Chatting Stuffs
    @Published var chattingModel:ChattingModel = ChattingModelView.createChattingModel()
    private var db = Firestore.firestore()
    private var currentContexts:[Context]?
//    MARK:- User/Session 정의되면 변경
    var userId :String?
    private(set) var realUID:String?
    private(set) var tutorialUID:String?
    var isOnTutorial = false{
        didSet{
            print(isOnTutorial)
        }
    }u7  
    private var currentSessionId : String = UUID().uuidString
    func setUserId(_ userId: String){
        if self.realUID == nil{
            self.userId = userId
            connectData()
        }
    }
    func userCameback(){
        // User 복귀시 로직을 다룸.
        if let lastMessage = self.chattingModel.messages.last{
            let calendar = Calendar.current
            let today = Date()
            if calendar.compare(today, to : lastMessage.sentTime, toGranularity: .day) == .orderedDescending{
                self.send(eventName: "user_cameback")
            }
        }
    }
    func connectData(){
        // TODO :- 여기서 연동 코드를 작성한다.
        if let userIdString = self.userId{
            print("userId가 \(userIdString)인 것을 가져온다." )
            db.collection("messages").whereField("userId", isEqualTo: userIdString)
                .addSnapshotListener(includeMetadataChanges: true)  { querySnapshot, error in
                    guard let documents = querySnapshot?.documents else {
                        print("Error fetching documents: \(error!)")
                        return
                    }
                    self.snapshotsToMessages(snapshots: querySnapshot!.documents)
                    self.currentContexts = self.chattingModel.getLastContexts()
                    self.checkTimerAndSet()
                }
        }
    }
    func snapshotsToMessages(snapshots:[QueryDocumentSnapshot]){
        self.chattingModel.messages = snapshots.compactMap{(querySnapshot) -> Message? in
            do{
                    
                        let message =  try querySnapshot.data(as:Message.self)
        //                Reply면 필요한 세팅을 위한 확인
                        if let message_ = message {
                            if message_.category == .reply, !message_.used{
                                self.chattingModel.setCurrentReplyMessage(message_)
                            }else if message_.category == .text, !message_.fromUser{
                                self.chattingModel.gotTextMessage()
                            }
                        }
                        return message
                } catch{
                    let message_:Message? = nil
                    return message_
                }

            }
        self.chattingModel.messages = self.chattingModel.messages.sorted(by: {$0.sentTime < $1.sentTime})
        }
    private func checkTimerAndSet(){
        var timerMessage = self.chattingModel.getUnusedTimer()
        if let timerMessageTemp = timerMessage{
            self.timerModel.setTimer(message:timerMessageTemp)
        }
    }
    private static func createChattingModel()->ChattingModel{
        let model = ChattingModel()
        return model
    }
    func addMessage(message:Message){
        do{
            let _ = try db.collection("messages").addDocument(from: message)
        }
        catch{
            print(error)
        }
    }
    func updateMessage(message:Message){
        do {
            let _ = try db.collection("messages").document(message.id!).setData(from: message)
        }
        catch{
            print(error)
        }
    }
    func setAllUsed(){
        self.timerModel.finishTimer()
        for (index,message) in self.chattingModel.messages.enumerated(){
            if (!message.used){
                self.chattingModel.messages[index].setReplyDone()
                self.updateMessage(message: self.chattingModel.messages[index])
            }
        }
    }
    func send(text : String){
        if let userIdString = self.userId {
            let newMessage = Message(
                text:text,
                userId: userIdString,
                sessionId:currentSessionId,
                contexts : currentContexts
            )
            self.setAllUsed()
            addMessage(message:newMessage)
        }else{
            print("userId비어있음")
        }
        self.sentMessage()
    }
    func send(eventName: String){
        if let userIdString = self.userId{
            let newEvent = Event(name: eventName)
            let newMessage = Message(
                event:newEvent,
                userId: userIdString,
                sessionId:currentSessionId,
                contexts : currentContexts
            )
            self.setAllUsed()
            addMessage(message: newMessage)
        }
        self.sentMessage()
    }
    func send(eventName: String,parameters:CustomParameters){
        if let userIdString = self.userId{
            let newEvent = Event(name: eventName,parameters: parameters)
            let newMessage = Message(
                event:newEvent,
                userId: userIdString,
                sessionId:currentSessionId,
                contexts : currentContexts
            )
            self.setAllUsed()
            addMessage(message: newMessage)
        }
        self.sentMessage()
    }
    func tapQuickReply(at quickReply: QuickReply, of message:Message){
        setAllUsed()
        self.updateMessageDone(of: message)
        sendPostback(postback: quickReply.payload)
    }
    private func updateMessageDone(of message:Message){
        let index = self.chattingModel.messages.firstIndex(of: message)
        if let index_ = index{
            self.chattingModel.messages[index_].setReplyDone()
            self.updateMessage(message: self.chattingModel.messages[index_])
        }
    }
    func sendPostback(postback: PostbackPayload){
        switch(postback.postbackType){
        case .event:
            if let eventName = postback.event{
                if let parameters = postback.parameters{
                    send(eventName: eventName,parameters: parameters)
                }else{
                    send(eventName: eventName)
                }

            }
        case .text:
            if let textInput = postback.text{
                send(text:textInput)
            }
        }
        self.sentMessage()
    }
    // MARK: - Dealing with Timer
    @Published var timerModel = TimerModel()
    // MARK: - TimerModel variables
    var timerMode:TimerMode?{
        timerModel.timerMode
    }
    var timerIsActive:Bool{
        return self.timerModel.isActive
    }
    var timerSecondsLeft:String{
        secondsToMinutesAndSeconds(seconds: self.timerModel.secondsLeft)
    }
    var timerImage:String{
        self.timerModel.imageUrl
    }
    var timerTitle:String{
        self.timerModel.title
    }
    // MARK: - Timer Intents
    func startTimer(){

        self.timerModel.timerMode = .running
        
        self.timerModel.timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true, block: { _ in
//            print(self.timerModel.secondsLeft)
            if self.timerModel.secondsLeft == 0 {
                self.endTimer()
            }else{
                self.timerModel.secondsLeft -= 1
            }

        })
//        timerModel.startTimer()
    }
    func pauseTimer(){
        timerModel.pauseTimer()
    }
    func resetTimer(){
        timerModel.resetTimer()
    }
    func endTimer(){
        timerModel.endTimer()
    }
    func finishTimer(withSuccess:Bool){
        self.timerModel.finishTimer()
        var message = self.timerModel.message!
        message.setReplyDone()
        self.updateMessage(message: message)
        let postback = self.timerModel.getPostback(withSuccess: withSuccess)
        self.sendPostback(postback: postback)
    }
//    MARK:- 임시조치. 개별 Message를 받으면, 그 Message의 위치를 찾고, 그 직전이 같은 값인지를 반환한다.
    func isDifferentBefore(message:Message)->Bool{
        var index = self.chattingModel.messages.firstIndex(matching: message)
        if let indexNumber = index, indexNumber != 0{
            if !self.chattingModel.messages[indexNumber-1].fromUser && !message.fromUser{
                return false
            }
        }
            return true
    }
//  MARK: - Chatting Status 관련

    var thinkingTimer : Timer?
    func startTextEditing(){
        self.chattingModel.setChattingStatus(.textEditing)
    }
    func stopTextEditing(){
        // sent해서 stopTextEditing이 들어온 거면 여기서 막는다.
        if self.chattingModel.chattingStatus != .thinking{
            self.chattingModel.setChattingStatus(.idle)
        }

    }
    func sentMessage(){
        self.chattingModel.setChattingStatus(.thinking)
        self.chattingModel.clearCurrentReplyMessage()
        self.startThinkingTimer()
    }
//    func gotMessageFromService(message: Message){
//        if let replyType = message.replyType{
//            switch(replyType) {
//            case .quickReply:
//                self.chattingModel.setChattingStatus(.replying)
//                self.chattingModel.setCurrentReplyMessage(currentReplyType: replyType, currentReplyMessage: message)
//            case .timer:
//                // Timer 시작 관련 코드를 이리로 가져온다.
//                self.chattingModel.setChattingStatus(.replying)
//            case .simpleInform:
//                self.chattingModel.setChattingStatus(.idle)
//            }
//        }else{
//            // Reply가 아님
//            self.chattingModel.setChattingStatus(.idle)
//        }
//        // Reply 받았을 때의 모든 동작 수행
//
//    }
    func getCurrentReplyMessage()->Message?{
        return self.chattingModel.currentReplyMessage
    }
    func getCurrentReplyType()->ReplyType?{
        return self.chattingModel.currentReplyType
    }
    func startThinkingTimer(){
        self.chattingModel.thinkingTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true, block: { _ in
            if self.chattingModel.secondsLeftForThinkingTimer == 0 {
                self.chattingModel.setChattingStatus(.idle)
                self.chattingModel.endThinkingTimer()
            }
            self.chattingModel.secondsLeftForThinkingTimer -= 1
        })
    }
    // MARK: - Tutorial 관련 코드
    func startTutorial(){
    // Client에서 랜덤하게 생성함으로, 튜토리얼을 끝내자마자 모두 지운다고 해도 문제가 생길 수 있다. 현실적으로 UUID는 겹치기 어렵다. 따라서 기존 Tutorial을 삭제하는 로직을 추가하지는 않는다.
        
        
        self.send(eventName: "start_tutorial")
    }
    
    private func endTutorial(){
        if self.userId == self.tutorialUID{
            self.userId = nil
        }
        self.isOnTutorial = false
    }
    func startViewSet(){
//  MARK: - Tutorial View가 떴을 때 세팅할 필요가 없는 것들이 세팅되면서, 앱의 튕김 현상이 생긴다. 이리 옮기자
        self.tutorialUID = UUID.init().uuidString
        self.userId = tutorialUID
        self.isOnTutorial = true
        self.connectData()
    }
    
    public func signUpSuccessCompletion(){
        if let successPostback = self.getCurrentReplyMessage()?.data.signUp?.successPostback{
            self.sendPostback(postback: successPostback)
            self.chattingModel.clearCurrentReplyMessage()
        }
        self.endTutorial()
    }

}
