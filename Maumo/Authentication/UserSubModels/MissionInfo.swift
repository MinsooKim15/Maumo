//
//  MissionInfo.swift
//  Maumo
//
//  Created by minsoo kim on 2021/02/01.
//

import Foundation
struct MissionInfo:Codable {
    var totalCount : Int
    var missionsDone : [String]
    var stamps : [String]
    var emotionTypeCount : [String:Int]
    var latestMission : String
}
