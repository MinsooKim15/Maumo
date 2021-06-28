//
//  MessageActionButtonView.swift
//  Maumo
//
//  Created by minsoo kim on 2021/06/18.
//

import SwiftUI

struct MessageActionButtonView: View {
    var buttonAction : ()->Void
    var titleTextSetting = FontSetting(fontWeight: .regular, fontSize: .medium20)
    var buttonMessage : String
    var failClosure:()->Void
    var image:String
    var body: some View {
        HStack{
            Spacer().frame(width:10)
            ZStack{
                Color.beigeWhite.clipShape(RoundedRectangle(cornerRadius: 5.0))
                VStack{
                    Spacer().frame(height:10)
                    HStack{
                        Spacer()
                        CloseButton(closeClosure:{failClosure()}, frameSize:50)
                            .padding([.trailing],10)
                    }
                    Spacer().frame(height:10)
                    HStack{
                        Spacer()
                        ImageView(withUrl:self.image)
                            .frame(width:60, height:60)
                        Spacer()
                    }
                    Spacer()
                    ZStack{
                        Color.salmon.clipShape(RoundedRectangle(cornerRadius: 5.0))
                            .shadow(radius:5)
                        Text(self.buttonMessage).foregroundColor(.white)
                    }.frame(width: 260, height:40)
                    .onTapGesture {
                        self.buttonAction()
                    }
                    Spacer().frame(height:10)
                }
                Spacer().frame(height:20)
    //            }
            }.frame(width: 280, height:200)
        }
    }
}

//struct MessageActionButtonView_Previews: PreviewProvider {
//    static var previews: some View {
//        MessageActionButtonView(buttonAction: {print("메시지")}, buttonMessage: "마음일기 쓰기", failClosure: {print("YEAH")})
//    }
//}
