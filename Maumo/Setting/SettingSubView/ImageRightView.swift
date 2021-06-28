//
//  ImageRightView.swift
//  Maumo
//
//  Created by minsoo kim on 2021/06/19.
//

import SwiftUI

struct ImageRightView: View {
    init() {
    }
    var body: some View {
        ZStack{
            Color.beigeWhite.ignoresSafeArea(.all)
            VStack{
                CustomNavigationBar(hasTitleText: true, titleText: "이미지 사용 내역",backgroundColor:Color.beigeWhite)
                Group{
                    HStack{
                        Spacer().frame(width:20)
                        Text("아래 Flaticon 작가들의 이미지 도움을 받아, MAUMO가 완성되었습니다.")
                        Spacer()
                    }
                    Divider()
                }
                Group{
                    HStack{
                        Spacer().frame(width:20)
                        Text("freepik")
                        Spacer()
                        Text("https://www.flaticon.com/kr/authors/freepik")
                        Spacer()
                    }
                    Divider()
                }
                Group{
                    HStack{
                        Spacer().frame(width:20)
                        Text("ddara")
                        Spacer()
                        Text("https://www.flaticon.com/kr/authors/ddara")
                        Spacer()
                    }
                    Divider()
                }
                Spacer()
            }
        }.dragToDismiss()
    }
}

struct ImageRightView_Previews: PreviewProvider {
    static var previews: some View {
        ImageRightView()
    }
}
