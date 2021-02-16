//
//  QuickReplyMessageView.swift
//  Maumo
//
//  Created by minsoo kim on 2021/01/31.
//

import SwiftUI
struct QuickReplyMessageView: View {
    var quickReplies: [QuickReply]
    @ObservedObject var modelView: MainModelView
    func tapQuickReply(quickReply: QuickReply){
        self.modelView.tapQuickReply(at: quickReply)
    }
    var body: some View {
        HStack{
            ForEach(quickReplies, id: \.self){ quickReply in
                QuickReplyBurbble(text: quickReply.title)
                    .onTapGesture {
                        tapQuickReply(quickReply: quickReply)
                    }
            }
        }

    }
}
struct QuickReplyBurbble:View{
    var text:String
    var body: some View{
        Text(text)
    }
}
