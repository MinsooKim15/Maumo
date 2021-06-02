//
//  TriggerButtonItem.swift
//  Maumo
//
//  Created by minsoo kim on 2021/05/31.

import Foundation
import Firebase
import FirebaseFirestoreSwift

struct TriggerButtonItem:Identifiable, Codable,Hashable{
    @DocumentID var id: String? = UUID().uuidString
    var title:String
    var imageUrl : String
    var triggerEvent : Event
    var update : Date
}
