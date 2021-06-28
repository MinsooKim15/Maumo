//
//  SentDateView.swift
//  Maumo
//
//  Created by minsoo kim on 2021/06/28.
//

import SwiftUI

struct SentDateView:View{
    var date:Date
    let textFont = FontSetting(fontWeight: .light, fontSize: .verySmall8)
    let textColor:Color = .purplishGrey
    func dateFormat(date:Date)->String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "hh:mm a"
        let timeFromDate = dateFormatter.string(from: date)
        return timeFromDate
    }
    var body: some View{
        Text("\(dateFormat(date:date))").adjustFont(fontSetting: self.textFont).foregroundColor(textColor)
    }
}

//struct SentDateView_Previews: PreviewProvider {
//    static var previews: some View {
//        SentDateView()
//    }
//}
