//
//  HideKeyboard.swift
//  Maumo
//
//  Created by minsoo kim on 2021/02/19.
//
import SwiftUI
extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

