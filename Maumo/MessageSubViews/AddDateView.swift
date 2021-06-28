//
//  AddDateView.swift
//  Maumo
//
//  Created by minsoo kim on 2021/06/28.
//

import SwiftUI

struct AddDateViewModifier: ViewModifier {
    var isCurrentUser : Bool
    var sentDate : Date
    func body(content:Content) -> some View {
        HStack{
            if self.isCurrentUser{
                VStack{
                    Spacer()
                    SentDateView(date: sentDate)
                }

            }
            content
            if !self.isCurrentUser{
                VStack{
                    Spacer()
                    SentDateView(date: sentDate)
                }

            }
        }
    }
}

extension View{
    func addDateView(isCurrentUser:Bool, sentDate:Date) -> some View{
        self.modifier(AddDateViewModifier(isCurrentUser: isCurrentUser, sentDate: sentDate))
    }
}
