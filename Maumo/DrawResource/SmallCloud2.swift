//
//  SmallCloud2.swift
//  Maumo
//
//  Created by minsoo kim on 2021/02/18.
//
// height : 88, width : 82

import SwiftUI
struct SmallCloud2: View{
    var body : some View{
            Path{ path in
                path.move(
                    to : CGPoint(
                        x: 38.1,
                        y: 86.81
                    )
                )
                path.addCurve(to: CGPoint(x: 80.62, y: 39.55), control1: CGPoint(x: 56.53, y: 86.81), control2: CGPoint(x: 80.62, y: 63.01))
                path.addCurve(to: CGPoint(x: 48.42, y: 0), control1: CGPoint(x: 80.62, y: 16.08), control2: CGPoint(x: 72.04, y: 0))
                path.addCurve(to: CGPoint(x: 0, y: 39.55), control1: CGPoint(x: 24.79, y: 0), control2: CGPoint(x: 0, y: 16.08))
                path.addCurve(to: CGPoint(x: 38.1, y: 86.81), control1: CGPoint(x: 0, y: 63.01), control2: CGPoint(x: 19.67, y: 86.81))
            }
            .fill(Color(UIColor(red: 250.0/255.0, green: 134.0/255.0, blue: 119.0/255.0, alpha: 1.0)))
            .aspectRatio(1, contentMode: .fit)
    }
}
