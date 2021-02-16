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
    private var userId :String = "arcaine34@gmail.com"
    private var currentSessionId : String = UUID().uuidString
    init(){
        connectData()
    }
    
    func connectData(){
        // TODO :- 여기서 연동 코드를 작성한다.
        db.collection("messages")
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
    func send(text : String){
        let newMessage = Message(
            text:text,
            userId: userId,
            sessionId:currentSessionId,
            contexts : currentContexts
        )
        addMessage(message:newMessage)
    }
    func send(eventName: String){
        let newEvent = Event(name: eventName)
        let newMessage = Message(
            event:newEvent,
            userId: userId,
            sessionId:currentSessionId,
            contexts : currentContexts
        )
        addMessage(message: newMessage)
    }
    func tapQuickReply(at quickReply: QuickReply){
        sendPostback(postback: quickReply.payload)
    }
    func sendPostback(postback: PostbackPayload){
        switch(postback.postbackType){
        case .event:
            if let eventName = postback.eventName{
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
    var timerSecondsLeft:Int{
        self.timerModel.secondsLeft
    }
    // MARK: - Timer Intents
    func startTimer(){

        self.timerModel.timerMode = .running
        
        self.timerModel.timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true, block: { _ in
            print(self.timerModel.secondsLeft)
            if self.timerModel.secondsLeft == 0 {
                self.endTimer()
            }
            self.timerModel.secondsLeft -= 1
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
        message.setTimerDone()
        self.updateMessage(message: message)
        let postback = self.timerModel.getPostback(withSuccess: withSuccess)
        self.sendPostback(postback: postback)
    }
}
