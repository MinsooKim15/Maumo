//
//  TextMessageView.swift
//  Maumo
//
//  Created by minsoo kim on 2021/01/31.
//

import SwiftUI

struct TextMessageView: View {
    var contentMessage: String
    var isCurrentUser: Bool
    let textFont = FontSetting(fontWeight: .regular, fontSize: .small14)
    
    var body: some View {
            Text(contentMessage)
                .adjustFont(fontSetting: textFont)
                .padding(10)
                .foregroundColor(isCurrentUser ? Color.black : Color.black)
                .background(isCurrentUser ? Color.whiteGreen : Color(UIColor(red: 240/255, green: 240/255, blue: 240/255, alpha: 1.0)))
                .cornerRadius(10)
            
    }
}

struct TextMessageView_Previews: PreviewProvider {
    static var previews: some View {
        TextMessageView(contentMessage: "다가올 인연의 외모/성격/직업은?", isCurrentUser: false)
    }
}
