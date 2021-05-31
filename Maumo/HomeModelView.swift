//
//  TempModelView.swift
//  Maumo
//
//  Created by minsoo kim on 2021/05/31.
//

import Foundation
import AppTrackingTransparency
import SwiftUI
class HomeModelView:ObservableObject{
    //    MARK:- User/Session 정의되면 변경
    // MARK: - App Tracking Transparency
        func callTransparencyPopupIfNeeded(){
            if #available(iOS 14, *) {
                if AppTrackingTransparency.ATTrackingManager.trackingAuthorizationStatus == .notDetermined{
                    AppTrackingTransparency.ATTrackingManager.requestTrackingAuthorization{status in
                        print(status)
                    }
                }
            }
        }
}
