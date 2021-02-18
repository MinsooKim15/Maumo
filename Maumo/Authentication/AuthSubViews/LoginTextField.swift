//
//  LoginTextField.swift
//  Maumo
//
//  Created by minsoo kim on 2021/02/18.
//

import SwiftUI
struct LoginTextField: View{
    var placeHolder : String
    @Binding var text: String
    let textFieldFontSetting = FontSetting(
        fontWeight: .regular,
        fontSize: .medium20)
    var body: some View{
        VStack(alignment: .leading, spacing:0){
            Group{
                TextField(placeHolder, text:$text)
            }
            .padding([.leading], 16)
            .padding([.bottom],9)
            .adjustFont(fontSetting: textFieldFontSetting)
            HorizontalLine(color: .beige)
        }.frame(height:16)
    }
}
