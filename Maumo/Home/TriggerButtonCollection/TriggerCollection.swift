//
//  TriggerCollection.swift
//  Maumo
//
//  Created by minsoo kim on 2021/05/31.
//

import Foundation
import Firebase
import FirebaseFirestoreSwift

struct TriggerCollection:Hashable,Identifiable,Codable{
    @DocumentID var id: String? = UUID().uuidString
    var title:String
    var itemList : [TriggerButtonItem]
    var created:Date
    var show:Bool
}
