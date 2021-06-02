//
//  User.swift
//  Maumo
//
//  Created by minsoo kim on 2021/02/01.
//

import Foundation
import Firebase
import FirebaseFirestoreSwift
struct User:Codable{
    @DocumentID var uid:String?
    var name :PersonName?
    var birthday : Date?
    var email : String?
    var isAnonymous : Bool
    var missionInfo : MissionInfo
    var linkedServiceInfo : LinkedServiceInfo
    var userContext : UserContext
    init(uid:String, firstName:String, lastName:String, email:String){
        self.uid = uid
        self.name = PersonName(first: firstName, last: lastName)
        self.email = email
        self.isAnonymous = false
        self.missionInfo = MissionInfo(totalCount: 0, missionsDone: [], stamps: [], emotionTypeCount: [String:Int](), latestMission: "")
        self.linkedServiceInfo = LinkedServiceInfo(serviceId: uid, sourceService: "maumo")
        self.userContext = UserContext(doingMission: false, doingMissionName: "", notificationGreeting: "", hasNotificationGreeting: false)
    }
    init(uid:String, firstName:String, lastName:String, email:String, isAnonymous: Bool){
        self.uid = uid
        self.name = PersonName(first: firstName, last: lastName)
        self.email = email
        self.isAnonymous = false
        self.missionInfo = MissionInfo(totalCount: 0, missionsDone: [], stamps: [], emotionTypeCount: [String:Int](), latestMission: "")
        self.linkedServiceInfo = LinkedServiceInfo(serviceId: uid, sourceService: "maumo")
        self.userContext = UserContext(doingMission: false, doingMissionName: "", notificationGreeting: "", hasNotificationGreeting: false)
        self.isAnonymous = isAnonymous
    }
}
