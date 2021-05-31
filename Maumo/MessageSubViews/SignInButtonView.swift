//
//  SignInButtonView.swift
//  Maumo
//
//  Created by minsoo kim on 2021/04/29.
//

import SwiftUI

struct SignUpButtonView: View {
    var buttonAction : ()->Void
    var titleTextSetting = FontSetting(fontWeight: .regular, fontSize: .medium20)
    var body: some View {
        ZStack{
            Color.beigeWhite.clipShape(RoundedRectangle(cornerRadius: 5.0))
//            VStack{
//
//                ZStack(alignment:.leading){
//=
//                    HStack{
//                        Spacer()
//                        Text("안녕!").adjustFont(fontSetting: self.titleTextSetting)
//                        Spacer()
//                    }
//                }.padding([.top],20)
//                Spacer()
                ZStack{
                    Color.salmon.clipShape(RoundedRectangle(cornerRadius: 5.0))
                    Text("MAUMO 시작하기").foregroundColor(.white)
                }.frame(width: 300, height:50)
                .onTapGesture {
                    self.buttonAction()
                }
                Spacer().frame(height:20)
//            }
        }.frame(width: 320, height:80)
    }
}

struct SignInButtonView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpButtonView(buttonAction: {print("Yeah")})
    }
}
