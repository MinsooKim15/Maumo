//
//  SimpleInformMessageView.swift
//  Maumo
//
//  Created by minsoo kim on 2021/01/31.
//

import SwiftUI

struct SimpleInformMessageView: View {
    var text : String = ""
    var fontSetting = FontSetting(fontWeight: .light, fontSize: .verySmall12)
    var body: some View {
        ZStack{
            HorizontalLine(color: .whiteGray)
            HStack{
                Spacer()
                Text(text)
                    .adjustFont(fontSetting: fontSetting)
                    .padding(10)
                    .background(Color.white)
                    .foregroundColor(Color.purplishGrey)
                Spacer()
            }
        }
        
    }
}
