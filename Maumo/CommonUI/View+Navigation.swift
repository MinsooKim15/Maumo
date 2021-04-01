//
//  View+Navigation.swift
//  Maumo
//
//  Created by minsoo kim on 2021/02/18.
//

import SwiftUI
extension View {

    /// Navigate to a new view.
    /// - Parameters:
    ///   - view: View to navigate to.
    ///   - binding: Only navigates when this condition is `true`.
    func navigate<NewView: View>(to view: NewView, when binding: Binding<Bool>) -> some View {
        GeometryReader { geometry in
            NavigationView {
                ZStack {
                    self
                        .navigationBarTitle("")
                        .navigationBarHidden(true)
                    NavigationLink(
                        destination: view
                            .navigationBarTitle("")
                            .navigationBarHidden(true),
                        isActive: binding
                    ) {
                        EmptyView()
                    }
                }
            }
            .navigationViewStyle(StackNavigationViewStyle())
            .padding(.leading, self.leadingPadding(geometry))
           }
    }
    private func leadingPadding(_ geometry: GeometryProxy) -> CGFloat {
        if UIDevice.current.userInterfaceIdiom == .pad {
            // A hack for correct display of the SplitView in SwiftUI on iPad
            return geometry.size.width < geometry.size.height ? 0.5 : -0.5
        }
        return 0
    }
}

