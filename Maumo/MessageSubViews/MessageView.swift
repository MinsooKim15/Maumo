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
    @ObservedObject var modelView: ChattingModelView
    var computedHeight : CGFloat{
        if let replyType = self.currentMessage.replyType{
            if (replyType == .signUp)||(replyType == .custom) || (replyType == .quickReply){
                return CGFloat(0)
            }else{
                return CGFloat(37)
            }
        }else{
            return CGFloat(37)
        }
    }
    var computedMaumoFace: some View{
        return Group{
            if self.isDifferentBefore{
                    Image("MaumoFace")
                    .resizable()
                    .frame(width: 44, height: computedHeight, alignment: .center)
                    .scaledToFit()
                
            }else{
                Spacer().frame(width: 44, height: computedHeight, alignment: .center)
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
                    TextMessageView(contentMessage: currentMessage.data.text ?? " ", isCurrentUser: currentMessage.fromUser).addDateView(isCurrentUser: currentMessage.fromUser, sentDate: currentMessage.sentTime)
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
    @ObservedObject var modelView: ChattingModelView
    var computedFrameHeight: CGFloat{
        switch(replyType){
        case .quickReply:
            return 0
        case .custom:
            return 0
        case .signUp:
            return 0
        default:
            return CGFloat.infinity
        }
    }
    var body: some View{
        Group{
            if (replyType == ReplyType.quickReply){
                EmptyView().frame(height:0.001)
            }else if(replyType == ReplyType.simpleInform){
                SimpleInformMessageView()
            }else if(replyType == ReplyType.timer){
                TimerMessageView(modelView:modelView,message:message)
            }else if(replyType == ReplyType.startVerticalService){
                MessageActionButtonView(
                            buttonAction: {self.modelView.showVerticalService(message: message)},
                            buttonMessage: self.message.data.startVerticalService!.buttonTitle,
                            failClosure: {self.modelView.sendPostback(postback: self.message.data.startVerticalService!.failPostback)},
                            image: self.message.data.startVerticalService!.image)
            }else{
                EmptyView().frame(height:0.001)
            }
        }.frame(maxHeight:self.computedFrameHeight)
    }
}
