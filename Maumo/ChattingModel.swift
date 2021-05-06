//
//  ChattingModel.swift
//  Maumo
//
//  Created by minsoo kim on 2021/01/31.
//

import Foundation
import Firebase
import FirebaseFirestoreSwift
import FirebaseFirestore

struct ChattingModel{
    var messages: Array<Message> = []
    public private(set) var chattingStatus : ChattingModel.ChattingStatus = .idle{
        didSet{
            if oldValue == .thinking{
                self.secondsLeftForThinkingTimer = self.secondsToWaitForThinking
                self.endThinkingTimer()
            }else if oldValue == .replying{
                self.clearCurrentReplyMessage()
            }
        }
    }
    
    private let secondsToWaitForThinking = 60
    public var secondsLeftForThinkingTimer = 60
    var thinkingTimer = Timer()

    public private(set) var currentReplyType: ReplyType?{
        didSet{
            print("currentReplyType Changed to : \(currentReplyType)")
        }
    }
    public private(set) var currentReplyMessage : Message?
    public var replyTypeChanged:Bool = false
//    mutating func snapshotsToMessages(snapshots:[QueryDocumentSnapshot]){
//        self.messages = snapshots.compactMap{(querySnapshot) -> Message? in
////            return try? querySnapshot.data(as:Message.self)
//            do{
//                let message =  try querySnapshot.data(as:Message.self)
////                Reply면 필요한 세팅을 위한 확인
//
//                if let message_ = message {
//                    if message_.category == .reply, !message_.used{
//                        self.setCurrentReplyMessage(message_)
//                    }else if message_.category == .text, !message_.fromUser{
//                        self.gotTextMessage()
//                    }
//                }
//                return message
//            } catch{
//                let message_:Message? = nil
//                return message_
//            }
//        }
//        self.messages = self.messages.sorted(by: {$0.sentTime < $1.sentTime})
//    }
    mutating func endThinkingTimer(){
        self.secondsLeftForThinkingTimer = self.secondsToWaitForThinking
        self.thinkingTimer.invalidate()
    }
    mutating func setCurrentReplyMessage(_  currentReplyMessage:Message){
        print("set current reply message")
        print(currentReplyMessage)
        self.chattingStatus = .replying
        self.currentReplyType = currentReplyMessage.replyType
        self.currentReplyMessage = currentReplyMessage
        self.replyTypeChanged = true
    }
    mutating func clearCurrentReplyMessage(){
        self.currentReplyType = nil
        self.currentReplyMessage = nil
        self.replyTypeChanged = true
    }
    mutating func gotTextMessage(){
        if self.chattingStatus == .thinking{
            self.chattingStatus = .idle
        }
    }
    func getUnusedTimer()->Message?{
        for message in self.messages{
            if let replyType_ = message.replyType, replyType_ == .timer{
                if let timerTemp = message.data.timer{
                    if !message.used{
                        return message
                    }
                }
            }
        }
        return nil
    }

    mutating func setChattingStatus(_ status: ChattingModel.ChattingStatus){
        self.chattingStatus = status
        switch(status){
        case .idle:
            self.currentReplyType = nil
            self.currentReplyMessage = nil
        case .textEditing:
            return
        case .replying:
            return
        case .thinking:
            return
        }
    }
    mutating func getLastContexts()->[Context]?{
        return self.messages.last?.contexts
    }
    enum ChattingStatus:String{
        case idle
        case textEditing
        case replying
        case thinking
    }
}
