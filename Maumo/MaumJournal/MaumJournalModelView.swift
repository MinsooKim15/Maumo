//
//  MaumJournalModelView.swift
//  Maumo
//
//  Created by minsoo kim on 2021/05/23.
//

import SwiftUI
import Foundation
import FirebaseCore
import FirebaseFirestore
import FirebaseFirestoreSwift
import Firebase

class MaumJournalModelView:ObservableObject {
    private var userId:String?
    @Published var maumJournalModel:MaumJournalModel = MaumJournalModelView.createJournalItemModel(){
        didSet{
            print("model Changed")
            print(maumJournalModel.journalItemList.count)
            print("count in modelView : \(self.maumJournalModel.journalItemList.count)")
        }
    }
    private var db = Firestore.firestore()
    private static func createJournalItemModel()->MaumJournalModel{
        let model = MaumJournalModel()
        return model
    }
    func connectData(){
        // TODO :- 여기서 연동 코드를 작성한다.
        if let userIdString = self.userId{
            db.collection("journalItems").whereField("userId", isEqualTo: userIdString)
                .addSnapshotListener { querySnapshot, error in
                    guard let documents = querySnapshot?.documents else {
                        print("Error fetching documents: \(error!)")
                        return
                    }
                    self.maumJournalModel.snapshotsToJournalItem(snapshots: querySnapshot!.documents)
                }
//            let doc_ref = db.collection("journalItems").whereField("userId", isEqualTo: userIdString)
//            doc_ref.getDocuments{(querySnapshot,error) in
//                guard let documents = querySnapshot?.documents else {
//                    print("Error fetching documents: \(error!)")
//                    return
//                }
//                self.maumJournalModel.snapshotsToJournalItem(snapshots: querySnapshot!.documents)
//            }
        }
    }
    private func addJournalItem(journalItem:JournalItem){
        do{
            let _ = try db.collection("journalItems").addDocument(from: journalItem)
        }
        catch{
            print(error)
        }
    }
    public var journalItemsInSummary:[JournalItem]{
        // 앞에 최대 4개만 반환한다.
        if self.maumJournalModel.journalItemList.count >= 4{
            return Array(self.maumJournalModel.journalItemList[..<4])
        }else{
            return self.maumJournalModel.journalItemList
        }
    }
    public func setUserId(_ userId:String){
        self.userId = userId
    }
    // MARK: - Writing 관련 Intent
    public func saveJournal(title:String, content:String,targetDate:Date,feeling:MaumJournalFeeling,feelingImage:String){
        if let userIdString = self.userId{
            let journalItem = JournalItem(title: title,
                        content: content,
                        targetDatetime: targetDate,
                        feeling: feeling,
                        feelingImage: feelingImage,
                        userId: userIdString,
                        verticalServiceId: "maumJournal")
            self.addJournalItem(journalItem: journalItem)
        }
    }
}
