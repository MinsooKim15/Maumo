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
        self.feeling = feeling
        self.feelingImage = feelingImage
        self.userId = userId
        self.verticalServiceId = verticalServiceId
    }
    mutating func update(with journalItem:JournalItem){
        self.title = journalItem.title
        self.content = journalItem.content
        self.updateDatetime = Date()
        self.feeling = journalItem.feeling
        self.feelingImage = journalItem.feelingImage
    }
    func targetDate(month: Bool, day:Bool,weekDay:Bool)->String{
        let cal = Calendar(identifier: .gregorian)
        let comps = cal.dateComponents([.weekday,.day,.month], from: self.targetDatetime)
        if day&&weekDay{
            return "\(comps.day!)(\(DateUtil.getWeekDayInKorean(of:comps.weekday ?? 1, inFull:false)))"
        }else if day&&month{
            return "\(comps.month!)/\(comps.day!)"
        }else if day{
            return "\(comps.month!)"
        }
        return ""
    }
    var targetDateInString:String{
        let cal = Calendar(identifier: .gregorian)
        let comps = cal.dateComponents([.weekday,.day], from: self.targetDatetime)
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "MM-dd D"
//        dateFormatter.string(from: self.date)
        return "\(comps.day!)(\(DateUtil.getWeekDayInKorean(of:comps.weekday ?? 1, inFull:false)))"
    }
    
}

//struct MaumJournalFeeling{
//    func imageUrl(of feelingEnum: MaumJournalFeelingEnum) -> String{
//        switch feelingEnum{
//            case .veryHappy:
//                return "VeryHappy"
//            case .happy:
//                return "happy"
//            case .soso:
//                return "soso"
//            case .sad:
//                return "sad"
//            case .angry:
//                return "angry"
//            case .cloudy:
//                return "cloudy"
//        }
//    }
//}

enum MaumJournalFeelingEnum:String,Codable,CaseIterable,Equatable,Hashable{
    case happy = "happy"
    case soso = "soso"
    case sad = "sad"
    case cloudy = "cloudy"
    case angry = "angry"
}
