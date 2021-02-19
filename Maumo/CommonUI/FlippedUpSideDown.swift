//
//  FlippedUpSideDown.swift
//  Maumo
//
//  Created by minsoo kim on 2021/02/18.
//

import SwiftUI
import Foundation
struct FlippedUpsideDown: ViewModifier {
   func body(content: Content) -> some View {
    content
        .rotationEffect(Angle.degrees(.pi))
      .scaleEffect(x: -1, y: 1, anchor: .center)
   }
}
extension View{
   func flippedUpsideDown() -> some View{
     self.modifier(FlippedUpsideDown())
   }
}
