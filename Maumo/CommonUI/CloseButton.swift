//
//  CloseButton.swift
//  Maumo
//
//  Created by minsoo kim on 2021/06/18.
//

import SwiftUI

struct CloseButton:View{
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    var closeClosure:()->Void
    func closeAction()->Void{
        self.presentationMode.wrappedValue.dismiss()
        self.closeClosure()
    }
    var body: some View{
        Button(action: {self.closeAction()},
               label: {Group{
                ZStack{
                    Circle()
                        .frame(width:36, height:36)
                        .foregroundColor(.white)
                    Image(systemName: "xmark")
                        .font(.system(size: 14))
                        .foregroundColor(.black)
                }
                .frame(width:60, height:60)
                .shadow(radius: 5)
            }})
        
    }
}


struct CloseButton_Previews: PreviewProvider {
    static var previews: some View {
        CloseButton(closeClosure: {print("Close Tapped")})
    }
}
