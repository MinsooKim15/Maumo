//
//  DragToDismiss.swift
//  Maumo
//
//  Created by minsoo kim on 2021/06/28.
//

import SwiftUI

struct DragToDismissModifier: ViewModifier {
    @State private var offset = CGSize.zero
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    func body(content:Content)-> some View {
        content
            .gesture(
                DragGesture()
                    .onChanged { gesture in
                        self.offset = gesture.translation
                    }

                    .onEnded { _ in
                        if abs(self.offset.width) > 100 {
                            // remove the card
                            self.presentationMode.wrappedValue.dismiss()
                        } else {
                            self.offset = .zero
                        }
                    }
            )
    }
}
extension View{
    func dragToDismiss() -> some View{
        self.modifier(DragToDismissModifier())
    }
}
//struct DragToDismiss_Previews: PreviewProvider {
//    static var previews: some View {
//        DragToDismiss()
//    }
//}
