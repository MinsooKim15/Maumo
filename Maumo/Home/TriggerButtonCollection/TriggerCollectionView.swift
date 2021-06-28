//
//  TriggerCollectionView.swift
//  Maumo
//
//  Created by minsoo kim on 2021/06/01.
//

import SwiftUI
struct TriggerCollectionView:View{
    @ObservedObject var modelView = TriggerCollectionModelView()
    
    var height : CGFloat{
//        MARK: - 나중에 Item개수 체크
        return CGFloat(240*self.modelView.triggerCollectionCount)
    }
    var body: some View{
            VStack{
                ForEach(self.modelView.triggerCollectionModel.triggerCollectionList){item in
                    TriggerCollectionItemView(triggerCollection: item, modelView: self.modelView)
                }

            }
            .frame(height:self.height)
    }
}
struct TriggerCollectionItemView: View {
    @EnvironmentObject var session:SessionStore
    var triggerCollection : TriggerCollection
    @ObservedObject var modelView: TriggerCollectionModelView
    let collectionHeight : CGFloat = 240
    let fontSetting = FontSetting(fontWeight: .bold, fontSize:.medium22)
    let collectionTitleColor:Color = .purplishGrey
    let collectionTitleAndFirstItemPaddingToLeading : CGFloat = 12
    let itemPaddingToLeft :CGFloat = 14
    let listPaddingToBottom : CGFloat = 12
    @State var willNavigateToChatView: Bool = false
    @State var event : Event?
    func triggerTapped(item:TriggerButtonItem){
        self.event = self.modelView.triggerTapped(item:item, of:triggerCollection)
        self.willNavigateToChatView = true
    }
    var body: some View {
            VStack(alignment: .leading){
                Text("마음이 편안해지는 시간")
                    .adjustFont(fontSetting: self.fontSetting)
                    .foregroundColor(.purplishGrey)
                    .padding([.leading],
                             self.collectionTitleAndFirstItemPaddingToLeading)
                Spacer()
                ScrollView(.horizontal){
                    HStack(alignment:.center, spacing:0){
                        Spacer().frame(width:self.collectionTitleAndFirstItemPaddingToLeading)
                        ForEach(self.triggerCollection.itemList, id: \.self){item in
                            TriggerButtonView(triggerItem: item, clickClosure: {self.triggerTapped(item:item)}).padding([.trailing],self.itemPaddingToLeft)
                        }
                        
                    }
                    .padding([.bottom,.top],self.listPaddingToBottom)
                }
                NavigationLink(destination: ChatView(modelView:ChattingModelView(userId: self.session.session?.uid, with: event ?? Event(name: "user_cameback") )).navigationBarTitle("")
                                .navigationBarHidden(true), isActive: self.$modelView.triggerCollectionModel.willNavigateToChatView){
                    EmptyView()
                }
    //            .padding([.bottom], self.listPaddingToBottom)
            }.frame(height:self.collectionHeight)
    }
}

