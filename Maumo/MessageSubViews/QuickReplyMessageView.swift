//
//  QuickReplyMessageView.swift
//  Maumo
//
//  Created by minsoo kim on 2021/01/31.
//

import SwiftUI
struct QuickReplyMessageView: View {
    var message: Message
    var quickReplies: [QuickReply]

    @ObservedObject var modelView: MainModelView
    func tapQuickReply(quickReply: QuickReply){
        self.modelView.tapQuickReply(at: quickReply, of:message)
    }
    var body: some View {
        Group{
            if !self.message.used{
                ScrollView(.horizontal){
                    HStack{
                        ForEach(quickReplies, id: \.self){ quickReply in
                            QuickReplyBurbble(text: quickReply.title)
                                .onTapGesture {
                                    tapQuickReply(quickReply: quickReply)
                                }
                        }

                    }
                }
            }else{
                EmptyView().frame(width:0,height:0)
            }
        }
    }
}
struct QuickReplyBurbble:View{
    let textFont = FontSetting(fontWeight: .regular, fontSize: .small16)
    var text:String
    var body: some View{
        Text(text)
            .adjustFont(fontSetting: textFont)
            .padding(10)
            .foregroundColor(Color.white)
            .background(Color.salmon)
            .cornerRadius(20)
            .lineLimit(1)
            .frame(maxWidth:.infinity)
    }
}
