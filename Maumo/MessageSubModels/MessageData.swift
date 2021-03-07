//
//  MessageData.swift
//  Maumo
//
//  Created by minsoo kim on 2021/01/31.
//
// MessageData에 들어갈 세부 값을 정의함
// Reply가 추가되면 여기서 파싱을 다룸
import Foundation

struct MessageData:Codable{
    
    var text : String?
    var event: Event?
    var quickReplies : [QuickReply]?
    var timer : ReplyTimer?
    var simpleInform : SimpleInform?
    var attachment: Attachment?
    init(text : String){
        self.text = text
    }
    init(event: Event){
        self.event = event
    }

}
extension MessageData : Hashable{
    static func == (lhs: MessageData, rhs: MessageData) -> Bool {
        return lhs.hashValue == rhs.hashValue
    }
    
    func hash(into hasher: inout Hasher){
        hasher.combine(text)
        hasher.combine(event)
        hasher.combine(quickReplies)
        hasher.combine(timer)
        hasher.combine(simpleInform)
        hasher.combine(attachment)
    }
}

// TODO : payload를 변경해야 하나
struct QuickReply:Codable,Hashable{
    var contentType : QuickReplyContentType
    var title : String
    var payload : PostbackPayload
}

struct PostbackPayload:Codable, Hashable{
    var postbackType : PostbackType
    var text: String?
    var event : String?

}
enum PostbackType:String, Codable, Hashable{
    case text
    case event
}

enum QuickReplyContentType:String,Codable, Hashable{
    case text
}
struct ReplyTimer:Codable,Hashable{
    var title:String
    var time:Int
    var imageUrl:String
    var successPostback: PostbackPayload
    var failPostback: PostbackPayload
}
struct SimpleInform:Codable, Hashable{
    var title:String
}
struct Attachment:Codable, Hashable{
    var attachmentType : AttachmentType
    var url : String
}
enum AttachmentType:String, Codable{
    case image
}
