//
//  TriggerCollectionModel.swift
//  Maumo
//
//  Created by minsoo kim on 2021/06/01.
//

import Foundation
import Firebase
import FirebaseFirestoreSwift
import FirebaseFirestore

struct TriggerCollectionModel{

    var triggerCollectionList:[TriggerCollection] = []{
        didSet{
            print("트리거 컬렉션 변경")
            print("개수 : \(self.triggerCollectionList.count)")
        }
    }
    var willNavigateToChatView = false
    public mutating func snapshotsToTriggerCollection(snapshots:[QueryDocumentSnapshot]){
        self.triggerCollectionList = snapshots.compactMap{(querySnapshot) -> TriggerCollection? in
            do{
                print("snapshot To 실행")
                let triggerCollection =  try querySnapshot.data(as:TriggerCollection.self)
                return triggerCollection
            }catch{
                print("Error info: \(error)")
                    let triggerCollection:TriggerCollection? = nil
                    return triggerCollection
            }
            }
    }
}
