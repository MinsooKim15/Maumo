//
//  EndEditing.swift
//  Maumo
//
//  Created by minsoo kim on 2021/02/06.
//

import Foundation
import SwiftUI
extension UIApplication {
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
