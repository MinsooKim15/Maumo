//
//  SmallCloud1.swift
//  Maumo
//
//  Created by minsoo kim on 2021/02/17.
//

import SwiftUI
struct SmallCloud: View{
    var body : some View{
//        ZStack{
//            Color.red
//        GeometryReader{ geometry in
            Path{ path in
                path.move(
                    to : CGPoint(
                        x : 10.09,
                        y : 68.43
                    )
                )
                path.addCurve(
                    to: CGPoint(x:58.09, y:63.6),
                    control1: CGPoint(x: 17.92, y: 70.66),
                    control2: CGPoint(x: 39.3, y: 68.12)
                )
                path.addCurve(
                    to: CGPoint(x: 139.89, y: 34.65),
                    control1: CGPoint(x: 93.74, y: 55.03),
                    control2: CGPoint(x: 139.89, y: 53.91)
                )
                path.addCurve(
                    to: CGPoint(x: 42.09, y: 1.43),
                    control1: CGPoint(x: 139.89, y: 5.26),
                    control2: CGPoint(x: 49.14, y: 1.43)
                )
                path.addCurve(
                    to: CGPoint(x: 10.09, y: 21.43),
                    control1: CGPoint(x: 35.04, y: 1.43),
                    control2: CGPoint(x: 10.09, y: -7.97)
                )
                path.addCurve(
                    to: CGPoint(x: 10.09, y: 68.43),
                    control1: CGPoint(x: 10.09, y: 50.82),
                    control2: CGPoint(x: -12.61, y: 61.96)
                )
            }
            .fill(Color(hue: 0.438, saturation: 0.228, brightness: 0.878))
            .aspectRatio(1, contentMode: .fit)
//        }
    }

//    }
}
