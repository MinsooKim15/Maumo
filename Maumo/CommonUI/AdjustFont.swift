//
//  AdjustFont.swift
//  Maumo
//
//  Created by minsoo kim on 2021/02/06.
//

import Foundation
//
//  AdjustFont.swift
//  HomeGuide
//
//  Created by minsoo kim on 2020/06/30.
//  Copyright © 2020 minsoo kim. All rights reserved.
//

import Foundation
import Foundation
import SwiftUI
struct FontModifier: AnimatableModifier{
    @Environment(\.sizeCategory) var sizeCategory
    var fontWeight: CustomFontWeight
    var fontSize : CustomFontSize
    
    
    init(fontWeight:CustomFontWeight, fontSize : CustomFontSize ){
        // 다짜고짜 fontSize만 주었을 때
        self.fontWeight = fontWeight
        self.fontSize = fontSize
        
    }
//    init(fontStyle: CustomFontStyle , fontColor : Color , weight: FontWeight){
//        self.fontStyle = fontStyle
//        self.font = getDefaultFontStyle()
//    }

    func body(content: Content) -> some View {
        content.font(getDefaultFontStyle())
    }
    func getDefaultFontStyle() -> Font{
        return Font.custom(self.fontWeight.rawValue, size: CGFloat(self.fontSize.rawValue))
    }
}
extension View{
//    func adjustFont(fontStyle: CustomFontStyle , fontColor : Color , weight: FontWeight) -> some View{
//        self.modifier(FontModifier(fontStyle: fontStyle, fontColor: fontColor, weight: weight))
//    }
    func adjustFont(fontWeight : CustomFontWeight, fontSize : CustomFontSize) -> some View{
        self.modifier(FontModifier(fontWeight : fontWeight, fontSize:fontSize))
    }
    func adjustFont(fontSetting : FontSetting) -> some View{
        self.modifier(FontModifier(fontWeight : fontSetting.fontWeight, fontSize:fontSetting.fontSize))
    }
}
struct FontSetting{
    var fontWeight : CustomFontWeight
    var fontSize : CustomFontSize
}

enum CustomFontWeight:String{
    case regular = "NanumSquareOTFR"
    case light = "NanumSquareOTFL"
    case bold = "NanumSquareOTFB"
    case extraBold = "NanumSquareOTFEB"
}
enum CustomFontSize:Int{
    
    case verySmall12 = 12
    case small14 = 14
    case small16 = 16
    case medium18 = 18
    case medium20 = 20
    case medium22 = 22
    case large40 = 40
}

