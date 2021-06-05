//
//  MaumJournalModel.swift
//  Maumo
//
//  Created by minsoo kim on 2021/05/23.
//

import Foundation
import Firebase
import FirebaseFirestoreSwift
import FirebaseFirestore

struct MaumJournalModel{

    var editingJournalItem:JournalItem?
    var hasToday:Bool{
        let targetItem = self.journalItemList.sorted(by: {$0.targetDatetime > $1.targetDatetime})[0]
        return self.checkToday(targetDate: targetItem.targetDatetime)
    }
    var journalItemList: Array<JournalItem> = []
    {didSet{
        if (self.journalItemList.count > 4){
            self.journalItemListInSummary = Array(self.journalItemList.sorted(by: {$0.targetDatetime > $1.targetDatetime})[0..<4])
        }else if(self.journalItemList.count>0){
            self.journalItemListInSummary = Array(self.journalItemList.sorted(by: {$0.targetDatetime > $1.targetDatetime})[0..<self.journalItemList.count])
        }
    }}
    public private(set) var journalItemListInSummary:Array<JournalItem> = []
    public mutating func snapshotsToJournalItem(snapshots:[QueryDocumentSnapshot]){
        self.journalItemList = snapshots.compactMap{(querySnapshot) -> JournalItem? in
            do{
                let journalItem =  try querySnapshot.data(as:JournalItem.self)
        //                Reply면 필요한 세팅을 위한 확인
                return journalItem
            }catch{
                    let journalItem:JournalItem? = nil
                    return journalItem
                }
            }
        self.journalItemList = self.journalItemList.sorted(by: {$0.targetDatetime < $1.targetDatetime})
        }
    private func checkToday(targetDate:Date)->Bool{
        let today = Date()
        let cal = Calendar(identifier: .gregorian)
        let todayComps = cal.dateComponents([.year,.month,.day], from: today)
        let targetComps = cal.dateComponents([.year,.month,.day], from: targetDate)
        if todayComps.year == targetComps.year{
            if todayComps.month == targetComps.month{
                if todayComps.day == targetComps.day{
                    return true
                }
            }
        }
        return false
    }
}
