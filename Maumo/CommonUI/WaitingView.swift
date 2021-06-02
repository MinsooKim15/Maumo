//
//  WaitingView.swift
//  Maumo
//
//  Created by minsoo kim on 2021/06/02.
//

import SwiftUI

struct WaitingView: View {
    
    var body: some View {
        Image("LaunchScreen")
            .resizable()
            .aspectRatio(contentMode: .fill)
            .ignoresSafeArea(.all)
    }
}

struct WaitingView_Previews: PreviewProvider {
    static var previews: some View {
        WaitingView()
    }
}
