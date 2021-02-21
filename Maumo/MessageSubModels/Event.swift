//
//  Event.swift
//  Maumo
//
//  Created by minsoo kim on 2021/01/31.
//

import Foundation
struct Event:Codable{
    var name:String
    var parameters:CustomParameters?
}
extension Event:Hashable{
    static func == (lhs: Event, rhs: Event) -> Bool {
            return lhs.hashValue == rhs.hashValue && lhs.hashValue == rhs.hashValue
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(name)
        hasher.combine(parameters)
    }
}
