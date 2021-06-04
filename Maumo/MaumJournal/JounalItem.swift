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
    var feeling : MaumJournalFeelingEnum
    var feelingImage : String
    var userId:String
    var verticalServiceId:String
    init(title:String,content:String, targetDatetime:Date, feeling:MaumJournalFeelingEnum, feelingImage:String, userId:String, verticalServiceId:String) {
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

struct MaumJournalFeeling{
    func imageUrl(of feelingEnum: MaumJournalFeelingEnum) -> String{
        switch feelingEnum{
            case .veryHappy:
                return "VeryHappy"
            case .happy:
                return "happy"
            case .soso:
                return "soso"
            case .sad:
                return "sad"
            case .angry:
                return "angry"
            case .cloudy:
                return "cloudy"
        }
    }
}

enum MaumJournalFeelingEnum:String,Codable,CaseIterable,Equatable{
    case veryHappy
    case happy
    case soso
    case sad
    case cloudy
    case angry
}
