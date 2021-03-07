//
//  MessageView.swift
//  Maumo
//
//  Created by minsoo kim on 2021/01/31.
//

import SwiftUI
struct MessageView : View {
    var currentMessage: Message
    var isDifferentBefore: Bool
    @ObservedObject var modelView: MainModelView
    var computedMaumoFace: some View{
        return Group{
            if self.isDifferentBefore{
                    Image("MaumoFace")
                    .resizable()
                    .frame(width: 44, height: 37, alignment: .center)
                    .scaledToFit()
                
            }else{
                Spacer().frame(width: 44, height: 37, alignment: .center)
            }
        }
    }
    var body: some View {
        HStack(alignment: .bottom, spacing: 15) {

        Group{
                if(!currentMessage.fromUser){
                    computedMaumoFace
                }else{
                    Spacer()
                }
        }
        Group{
            if currentMessage.category == MessageCategory.text{
                TextMessageView(contentMessage: currentMessage.data.text ?? "값이 없음", isCurrentUser: currentMessage.fromUser)
            }else if(currentMessage.category == MessageCategory.attachment){
                AttachmentView(attachment: currentMessage.data.attachment!,fromUser: currentMessage.fromUser)
            }else if(currentMessage.category == MessageCategory.reply){
                ReplyView(message : currentMessage, replyType : currentMessage.replyType!, replyData: currentMessage.data, fromUser: currentMessage.fromUser, modelView:modelView)
             }else{
                EmptyView()
            }
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
    var message: Message
    var replyType : ReplyType
    var replyData : MessageData
    var fromUser : Bool
    @ObservedObject var modelView: MainModelView
    var body: some View{
        Group{
            if (replyType == ReplyType.quickReply){
                QuickReplyMessageView(message:message, quickReplies: replyData.quickReplies ?? [QuickReply](), modelView: modelView)
            }else if(replyType == ReplyType.simpleInform){
                SimpleInformMessageView()
            }else if(replyType == ReplyType.timer){
                TimerMessageView(modelView:modelView,message:message)
            }else{
                SimpleInformMessageView()
            }
        }
    }
}
