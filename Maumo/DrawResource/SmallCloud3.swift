////
////  SmallCloud3.swift
////  Maumo
////
////  Created by minsoo kim on 2021/05/16.
////
//
//import SwiftUI
//
//struct SmallCloud3: Shape {
//    func path(in rect: CGRect) -> Path {
//        var path = Path()
//        let width = rect.size.width
//        let height = rect.size.height
//        path.addRect(CGRect(x: 0, y: 0, width: 7.26316*width, height: 14.68852*height))
//        path.move(to: CGPoint(x: 0.43786*width, y: 0.99779*height))
//        path.addCurve(to: CGPoint(x: 0.95357*width, y: 0.45454*height), control1: CGPoint(x: 0.66137*width, y: 0.99779*height), control2: CGPoint(x: 0.95357*width, y: 0.72422*height))
//        path.addCurve(to: CGPoint(x: 0.56301*width, y: 0), control1: CGPoint(x: 0.95357*width, y: 0.18487*height), control2: CGPoint(x: 0.84954*width, y: 0))
//        path.addCurve(to: CGPoint(x: -0.02426*width, y: 0.45454*height), control1: CGPoint(x: 0.27648*width, y: 0), control2: CGPoint(x: -0.02426*width, y: 0.18487*height))
//        path.addCurve(to: CGPoint(x: 0.43786*width, y: 0.99779*height), control1: CGPoint(x: -0.02426*width, y: 0.72422*height), control2: CGPoint(x: 0.21435*width, y: 0.99779*height))
//        path.closeSubpath()
//        return path
//    }
//}
//struct SmallCloud3: View{
//    var body : some View{
//            Path{ path in
//                path.move(
//                    to : CGPoint(
//                        x: 38.1,
//                        y: 86.81
//                    )
//                )
//                path.addCurve(to: CGPoint(x: 80.62, y: 39.55), control1: CGPoint(x: 56.53, y: 86.81), control2: CGPoint(x: 80.62, y: 63.01))
//                path.addCurve(to: CGPoint(x: 48.42, y: 0), control1: CGPoint(x: 80.62, y: 16.08), control2: CGPoint(x: 72.04, y: 0))
//                path.addCurve(to: CGPoint(x: 0, y: 39.55), control1: CGPoint(x: 24.79, y: 0), control2: CGPoint(x: 0, y: 16.08))
//                path.addCurve(to: CGPoint(x: 38.1, y: 86.81), control1: CGPoint(x: 0, y: 63.01), control2: CGPoint(x: 19.67, y: 86.81))
//            }
//            .fill(Color(UIColor(red: 250.0/255.0, green: 134.0/255.0, blue: 119.0/255.0, alpha: 1.0)))
//            .aspectRatio(1, contentMode: .fit)
//    }
//}
