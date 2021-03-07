//
//  SimpleInformMessageView.swift
//  Maumo
//
//  Created by minsoo kim on 2021/01/31.
//

import SwiftUI

struct SimpleInformMessageView: View {
    var text : String = ""
    var body: some View {
        Text(text)
            .padding(10)
            .foregroundColor(Color.white)
            .background(Color.blue)
            .cornerRadius(10)
    }
}
