//
//  TriggerButtonView.swift
//  Maumo
//
//  Created by minsoo kim on 2021/05/31.
//

import SwiftUI

struct TriggerButtonView: View {
    var triggerItem:TriggerButtonItem
    var clickClosure:()->Void
    let cornerRadius : CGFloat = 10
    let titlePaddingToLeading :CGFloat = 20
    let titlePaddingToTop:CGFloat = 20
    let imagePaddingToTrailing:CGFloat = 20
    let imagePaddingToBottom:CGFloat = 20
    let imageHeight:CGFloat = 40
    let imageWidth: CGFloat = 40
    let frameWidth : CGFloat = 175
    let frameHeight : CGFloat = 184
    let titleFontSetting : FontSetting = FontSetting(fontWeight: .bold, fontSize: .medium20)
    var body: some View {
        Button(action:clickClosure){
            ZStack{
                RoundedRectangle.init(cornerRadius: self.cornerRadius).foregroundColor(.beigeWhite)
                    .shadow(color: .black, radius: 2, x: 0, y: 2)
                VStack{
                    HStack{
                        Text(self.triggerItem.title)
                        .lineLimit(2)
                            .multilineTextAlignment(.leading).foregroundColor(.black)
                            .fixedSize(horizontal: false, vertical: true)
                            .adjustFont(fontSetting: self.titleFontSetting)
                            .padding([.top], self.titlePaddingToTop)
                            .padding([.leading], self.titlePaddingToLeading)
                        Spacer()
                    }
                    Spacer()
                    HStack{
                        Spacer()
                        Image("SmallCloud2")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: self.imageWidth, height: self.imageHeight)
                            .padding([.trailing], self.imagePaddingToTrailing)
                            .padding([.bottom], self.imagePaddingToBottom)
                    }

                }
            }.frame(width:self.frameWidth, height : self.frameHeight)
        }
    }
}
//
//struct TriggerButtonView_Previews: PreviewProvider {
//    static var previews: some View {
//        TriggerButtonView(clickClosure: {print("done")})
//    }
//}
