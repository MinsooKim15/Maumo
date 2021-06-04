//
//  MaumChooseView.swift
//  Maumo
//
//  Created by minsoo kim on 2021/06/04.
//

import SwiftUI

struct MaumChooseView: View {
    let viewHeight:CGFloat = 40
    let imageWidth:CGFloat = 30
    let imageHeight:CGFloat = 30
    let itemPaddingToTrailing:CGFloat = 20
    let viewPaddingToLeading:CGFloat = 20
    var backgroundColor:Color = .beigeWhite
    var closure :(MaumJournalFeelingEnum) -> Void
    var body: some View {
        ZStack{
            backgroundColor
            ScrollView(.horizontal){
                HStack{
                    ForEach(MaumJournalFeelingEnum.allCases, id:\.self){feeling in
                        Image("SmallCloud2").resizable()
                            .frame(width: self.imageWidth, height:self.imageHeight)
                            .padding([.trailing],self.itemPaddingToTrailing)
                            .onTapGesture {
                                self.closure(feeling)
                            }
                        
                    }
                }.padding([.leading],self.viewPaddingToLeading)
            }
        }
       .frame(height:self.viewHeight)
    }
}

struct MaumChooseView_Previews: PreviewProvider {
    static var previews: some View {
        MaumChooseView(closure: {data in
            print(data)
        })
    }
}
