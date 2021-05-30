//
//  JounalItem.swift
//  Maumo
//
//  Created by minsoo kim on 2021/05/23.
//

import Foundation
import Firebase
import FirebaseFirestoreSwift

struct JournalItem:Hashable,Identifiable,Codable{
    @DocumentID var id: String? = UUID().uuidString
    var title : String
    var targetDatetime : Date
    var createDatetime : Date
    var updateDatetime : Date
    var content : String
    var feeling : MaumJournalFeeling
    var feelingImage : String
    var userId:String
    var verticalServiceId:String
    init(title:String,content:String, targetDatetime:Date, feeling:MaumJournalFeeling, feelingImage:String, userId:String, verticalServiceId:String) {
        self.title = title
        self.content = content
        self.targetDatetime = targetDatetime
        self.createDatetime = Date()
        self.updateDatetime = Date()
        self.content = content
        self.feeling = feeling
        self.feelingImage = feelingImage
        self.userId = userId
        self.verticalServiceId = verticalServiceId
    }
}

enum MaumJournalFeeling:String,Codable{
    case happy
}
