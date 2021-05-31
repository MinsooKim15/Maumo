//
//  SignInButtonView.swift
//  Maumo
//
//  Created by minsoo kim on 2021/04/29.
//

import SwiftUI

struct MessageButtonView: View {
    var buttonAction : ()->Void
    var titleTextSetting = FontSetting(fontWeight: .regular, fontSize: .medium20)
    var buttonMessage : String
    var body: some View {
        HStack{
            Spacer().frame(width:10)
            ZStack{
                Color.beigeWhite.clipShape(RoundedRectangle(cornerRadius: 5.0))

                    ZStack{
                        Color.salmon.clipShape(RoundedRectangle(cornerRadius: 5.0))
                        Text(self.buttonMessage).foregroundColor(.white)
                    }.frame(width: 260, height:50)
                    .onTapGesture {
                        self.buttonAction()
                    }
                    Spacer().frame(height:20)
    //            }
            }.frame(width: 280, height:80)
        }

    }
}

//struct SignInButtonView_Previews: PreviewProvider {
//    static var previews: some View {
//        SignUpButtonView(buttonAction: {print("Yeah")})
//    }
//}
