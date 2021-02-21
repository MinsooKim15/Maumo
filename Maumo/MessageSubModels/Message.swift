//
//  Message.swift
//  Maumo
//
//  Created by minsoo kim on 2021/01/31.
//

import Foundation
import Firebase
import FirebaseFirestoreSwift

struct Message : Identifiable, Codable,Hashable{
    @DocumentID var id: String? = UUID().uuidString
    var userId : String
    var category : MessageCategory
    var replyType : ReplyType?
    var fromUser: Bool
    var sentTime : Date
    var sessionId: String
    var contexts : [Context]
    var data : MessageData
    var used : Bool
    
//    init(snapshot:QueryDocumentSnapshot){
//        id = snapshot.documentId
//        let snapshotValue = snapshot.data()
//        userId = (snapshot["userId"] as! String)
//        category = (snapshot["category"] as! MessageCategory)
//        replyType = (snapshot["replyType"] as! ReplyType)
//        fromUser = (snapshot["fromUser"] as! Bool)
//        sentTime = (snapshot["sentTime"] as! Tomestamp)?.dateValue()
//        sessionId = (snapshot["sessionid"] as! String)
//        contexts = [Context]()
//        if let contextDictionaryList = snapshotValue["contexts"] as? [Dictionary<String,Any>]{
//            for contextDictionary in contextDictionaryList{
//                contexts.append(context: contextDictionary)
//            }
//        }
//
//    }
    init(text: String,userId:String, sessionId:String, contexts:[Context]?){
        id = UUID().uuidString
        self.userId = userId
        category = .text
        fromUser = true
        sentTime = Date()
        self.sessionId = sessionId
        self.used = false
        if contexts != nil{
            self.contexts = contexts!
        }else{
            self.contexts = [Context]()
        }
        data = MessageData(text: text)
    }
    init(event:Event,userId:String, sessionId:String, contexts:[Context]?){
        id = UUID().uuidString
        self.userId = userId
        category = .event
        fromUser = true
        sentTime = Date()
        self.sessionId = sessionId
        self.used = false
        if contexts != nil{
            self.contexts = contexts!
        }else{
            self.contexts = [Context]()
        }
        data = MessageData(event:event)
    }
    mutating func setReplyDone(){
        self.used = true
    }
}



enum MessageCategory:String,Codable{
    case text
    case event
    case reply
    case attachment
}
enum ReplyType:String,Codable{
    case quickReply
    case timer
    case simpleInform
}
