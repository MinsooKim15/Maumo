//
//  TriggerCollectiionModelView.swift
//  Maumo
//
//  Created by minsoo kim on 2021/06/01.
//

import SwiftUI
import Foundation
import FirebaseCore
import FirebaseFirestore
import FirebaseFirestoreSwift
import Firebase

class TriggerCollectionModelView : ObservableObject {
    @Published var triggerCollectionModel:TriggerCollectionModel
    private var db = Firestore.firestore()
    
    init(){
        self.triggerCollectionModel = TriggerCollectionModel()
        self.getData()
    }
    func triggerTapped(item:TriggerButtonItem, of triggerCollection:TriggerCollection)->Event{
        self.triggerCollectionModel.willNavigateToChatView = true
        return item.triggerEvent
    }
    public var triggerCollectionCount:Int{
        return self.triggerCollectionModel.triggerCollectionList.count
    }
    func getData(){
        // TODO :- 여기서 연동 코드를 작성한다.
        db.collection("triggerCollections")
            .whereField("show", isEqualTo: true)
            .order(by: "created", descending: true).limit(to: 2)
                .getDocuments{ querySnapshot, error in
                    guard let documents = querySnapshot?.documents else {
                        print("Error fetching documents: \(error!)")
                        return
                    }
                    self.triggerCollectionModel.snapshotsToTriggerCollection(snapshots: querySnapshot!.documents)
                }
        }
}
