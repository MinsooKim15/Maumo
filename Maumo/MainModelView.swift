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
// TODO : ChangeName
class MainModelView:ObservableObject{
//    MARK: - Chatting Stuffs
    @Published var chattingModel:ChattingModel = MainModelView.createChattingModel()
    private var db = Firestore.firestore()
    private var currentContexts:[Context]?
//    MARK:- User/Session 정의되면 변경
    var userId :String?
    private var currentSessionId : String = UUID().uuidString
    func setUserId(_ userId: String){
        self.userId = userId
        connectData()
    }
    var getUserid:String{
        return self.userId!
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
//            print("userId가 \(userIdString)인 것을 가져온다." )
            db.collection("messages").whereField("userId", isEqualTo: userIdString)
                .addSnapshotListener(includeMetadataChanges: true)  { querySnapshot, error in
                    guard let documents = querySnapshot?.documents else {
                        print("Error fetching documents: \(error!)")
                        return
                    }
                    self.chattingModel.snapshotsToMessages(snapshots: querySnapshot!.documents)
                    self.currentContexts = self.chattingModel.getLastContexts()
                    self.checkTimerAndSet()
                }
        }
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
        }
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
    }
    func tapQuickReply(at quickReply: QuickReply, of message:Message){
        setAllUsed()
        sendPostback(postback: quickReply.payload)
    }
    func sendPostback(postback: PostbackPayload){
        switch(postback.postbackType){
        case .event:
            if let eventName = postback.event{
                send(eventName: eventName)
            }
        case .text:
            if let textInput = postback.text{
                send(text:textInput)
            }
        }
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
}
