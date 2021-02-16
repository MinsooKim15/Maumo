//
//  MessageView.swift
//  Maumo
//
//  Created by minsoo kim on 2021/01/31.
//

import SwiftUI
struct MessageView : View {
    var currentMessage: Message
    @ObservedObject var modelView: MainModelView
    var body: some View {
        Group{
            if currentMessage.category == MessageCategory.text{
                HStack(alignment: .bottom, spacing: 15) {
                    if !currentMessage.fromUser {
                        Image("아이유")
                        .resizable()
                        .frame(width: 40, height: 40, alignment: .center)
                        .cornerRadius(20)
                    } else {
                        Spacer()
                    }
                    TextMessageView(contentMessage: currentMessage.data.text ?? "값이 없음",
                                    isCurrentUser: currentMessage.fromUser)
                }
            }else if(currentMessage.category == MessageCategory.attachment){
                AttachmentView(attachment: currentMessage.data.attachment!,fromUser: currentMessage.fromUser)
            }else if(currentMessage.category == MessageCategory.reply){
                ReplyView(replyType : currentMessage.replyType!, replyData: currentMessage.data, fromUser: currentMessage.fromUser, modelView:modelView)
            }else{
                Text("이벤트")
            }
        }
    }
}
struct AttachmentView:View{
    var attachment: Attachment
    var fromUser : Bool
    var body: some View{
        Group{
            if attachment.attachmentType == AttachmentType.image{
                ImageMessageView(withUrl: attachment.url, isCurrentUser: fromUser)
            }
        }
    }
}
struct ReplyView:View{
    var replyType : ReplyType
    var replyData : MessageData
    var fromUser : Bool
    @ObservedObject var modelView: MainModelView
    var body: some View{
        Group{
            if (replyType == ReplyType.quickReply){
                QuickReplyMessageView(quickReplies: replyData.quickReplies ?? [QuickReply](), modelView: modelView)
            }else if(replyType == ReplyType.simpleInform){
                SimpleInformMessageView()
            }else if(replyType == ReplyType.timer){
                TimerMessageView(modelView:modelView,timer:replyData.timer!)
            }else{
                SimpleInformMessageView()
            }
        }
    }
    
}
