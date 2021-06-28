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
    public var userId:String?
//    CalendarView 그리기와 JournalItem 리스트 가져오기가 동시에 수행되어서, 보이지가 않는다. 조금 들고 있다가, 바뀌는 순간에 그리자
    @Published var readyToShowCalendar:Bool = false
    @Published var maumJournalModel:MaumJournalModel = MaumJournalModelView.createJournalItemModel(){
        didSet{
            print("model Changed")
            print(maumJournalModel.journalItemList.count)
            print("count in modelView : \(self.maumJournalModel.journalItemList.count)")
        }
    }
    init(){
        
    }
    init(userId:String?){
        self.userId = userId
        self.connectData()
    }
    @Published var state : MaumJournalState = .none
    private var db = Firestore.firestore()
    private static func createJournalItemModel()->MaumJournalModel{
        let model = MaumJournalModel()
        return model
    }
    public func startEditing(with journalItem:JournalItem){
        self.state = .editing
        self.maumJournalModel.editingJournalItem = journalItem
    }
    public func startNewEditing(){
        self.maumJournalModel.editingJournalItem = nil
        self.state = .creating
        if !self.hasJournalItem(of: Date()){
            if let userIdString = self.userId{
                self.maumJournalModel.editingJournalItem = JournalItem(title: "", content: "", targetDatetime: Date(), feeling: .happy, feelingImage: "a", userId: userIdString, verticalServiceId: "maumJournal")
                
            }
        }else{
            print("has one")
        }
    }
    public func startCreatingFromChat(){
        self.maumJournalModel.editingJournalItem = nil
        self.state = .creating
        if !self.hasJournalItem(of: Date()){
            if let userIdString = self.userId{
                self.maumJournalModel.editingJournalItem = JournalItem(title: "", content: "", targetDatetime: Date(), feeling: .happy, feelingImage: "a", userId: userIdString, verticalServiceId: "maumJournal")
            }
        }else{
            print("has one")
        }
    }
    public var editingJournalItemTitle:String{
        return self.maumJournalModel.editingJournalItem?.title ?? ""
    }
    public var editingJournalItemContent:String{
        return self.maumJournalModel.editingJournalItem?.content ?? ""
    }
    public var editingJournalItemFeeling:MaumJournalFeelingEnum?{
        return self.maumJournalModel.editingJournalItem?.feeling
    }
    public var editingJournalItemFeelingImage:String{
        return self.maumJournalModel.editingJournalItem?.feelingImage ?? ""
    }
    public var editingJournalItemFeelingDate:Date?{
        return self.maumJournalModel.editingJournalItem?.targetDatetime
    }
    public var editingJournalItemId:String?{
        return self.maumJournalModel.editingJournalItem?.id ?? nil
    }
    public func connectData(){
        // TODO :- 여기서 연동 코드를 작성한다.
        if let userIdString = self.userId{
            print("UserId가 있어서 journalIttems가져옴")
//            db.collection("journalItems").whereField("userId", isEqualTo: userIdString)
//                .addSnapshotListener { querySnapshot, error in
//                    guard let documents = querySnapshot?.documents else {
//                        print("Error fetching documents: \(error!)")
//                        return
//                    }
//                    self.maumJournalModel.snapshotsToJournalItem(snapshots: querySnapshot!.documents)
//                }
            let doc_ref = db.collection("journalItems").whereField("userId", isEqualTo: userIdString)
            doc_ref.getDocuments{(querySnapshot,error) in
                guard let documents = querySnapshot?.documents else {
                    print("Error fetching documents: \(error!)")
                    return
                }
                self.maumJournalModel.snapshotsToJournalItem(snapshots: querySnapshot!.documents)
                self.readyToShowCalendar = true
            }
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
    private func updateJournalItem(journalItem:JournalItem){
        if journalItem.id != nil{
            do{
                let _ = try db.collection("journalItems").document(journalItem.id!).setData(from: journalItem)
            }
            catch{
                print(error)
            }

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
    public func saveJournal(title:String, content:String,targetDate:Date,feeling:MaumJournalFeelingEnum,feelingImage:String, id:String?){
        self.state = .none
        if let userIdString = self.userId{
            let journalItem = JournalItem(title: title,
                        content: content,
                        targetDatetime: targetDate,
                        feeling: feeling,
                        feelingImage: feelingImage,
                        userId: userIdString,
                        verticalServiceId: "maumJournal")
            var targetItem = journalItem
            if (self.editingJournalItemId != nil)&&(id != nil){
                if self.editingJournalItemId! == id!{
                    
                    self.maumJournalModel.editingJournalItem?.update(with:journalItem)
                    targetItem = self.maumJournalModel.editingJournalItem!
                    print("update item")
                    updateJournalItem(journalItem: targetItem)
                    return
                }
            }
            self.addJournalItem(journalItem: targetItem)
        }
    }
    public func getSplitedJournalList(of index:Int, interval:Int, lastIndex:Int)->[JournalItem]{
        if index == lastIndex-1{
            return Array(self.maumJournalModel.journalItemList[index*interval..<self.maumJournalModel.journalItemList.count])
        }else{
            return Array(self.maumJournalModel.journalItemList[index*interval..<(index+1)*interval])
        }
    }
//    MARK : CalenderMainView 관련
    public func hasJournalItem(of targetDate:Date)->Bool{
        let targetItem = self.getJournalItem(of: targetDate)
        if targetItem != nil{
            return true
        }else{
            return false
        }
    }
    public func getJournalItemColor(of targetDate:Date)->Color{
        let targetItem = self.getJournalItem(of: targetDate)
        if targetItem != nil{
            return MaumJournalFeelingEnum.colorValue(targetItem!.feeling ?? MaumJournalFeelingEnum.happy)
        }else{
            return .white
        }
    }
    private func getJournalItem(of targetDate:Date)->JournalItem?{
        for item in self.maumJournalModel.journalItemList{
            if targetDate.distance(from: item.targetDatetime, only: .day) == 0{
                if targetDate.distance(from: item.targetDatetime, only: .month) == 0, targetDate.distance(from: item.targetDatetime, only: .year) == 0{
                    return item
                }
            }
        }
        return nil
    }
    public func checkNeedPurchase()->Bool{
        if self.maumJournalModel.journalItemList.count > 4{
            if self.state == .creating{
                return !UserDefaults.standard.bool(forKey:VerticalServiceId.JournalService_MaumDiary.rawValue)
            }else{
                return false
            }
        }else{
            return false
        }
    }
}
enum MaumJournalState{
    // 기존 일기를 수정 중임
    case editing
    // 기타 상태 -> 시작 상태임.
    case none
    // 기존 일기를 조회 중임. -> 개발 필요
    case viewing
    // 새로 만들고 있음
    case creating
}
