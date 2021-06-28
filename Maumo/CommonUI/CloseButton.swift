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
    var frameSize:CGFloat = 60
    func closeAction()->Void{
        
        self.closeClosure()
    }
    var body: some View{
        Button(action: {self.closeAction()},
               label: {Group{
                ZStack{
                    Circle()
                        .frame(width:frameSize*0.6, height:frameSize*0.6)
                        .foregroundColor(.white)
                    Image(systemName: "xmark")
                        .font(.system(size: frameSize*0.2))
                        .foregroundColor(.black)
                }
                .frame(width:self.frameSize, height:self.frameSize)
                .shadow(radius: 5)
            }})
        
    }
}


struct CloseButton_Previews: PreviewProvider {
    static var previews: some View {
        CloseButton(closeClosure: {print("Close Tapped")})
    }
}
