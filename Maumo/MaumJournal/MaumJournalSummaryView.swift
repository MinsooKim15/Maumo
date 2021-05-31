//
//  MaumJournalSummaryView.swift
//  Maumo
//
//  Created by minsoo kim on 2021/05/23.
//
// 마음일기 summary view
import SwiftUI

struct MaumJournalSummaryView: View {
    @EnvironmentObject var session:SessionStore
    
    @ObservedObject var modelView : MaumJournalModelView
    @State var willMoveToWritingFullView = false
    let viewWidth :CGFloat = 368
    let viewHeight :CGFloat = 184
    let viewRadius :CGFloat = 10.0
    let paddingFromActionButtonToBottom : CGFloat = 24.0
    func setUserId(){
        if let userIdString =  self.session.session?.uid{
            print(userIdString)
            self.modelView.setUserId(userIdString)
        }
    }
    var body: some View {
        ZStack{
            RoundedRectangle(cornerRadius: self.viewRadius)
                .foregroundColor(.beigeWhite)

            VStack{
                Spacer()
                Text("\(self.modelView.maumJournalModel.journalItemList.count)")
//                SummaryGrid(journalItemList: modelView.maumJournalModel.journalItemList)
                SummaryGrid(modelView:self.modelView)
                Spacer()
                SummaryActionButton(title:"마음 일기 쓰기", completion: {
                                        self.willMoveToWritingFullView = true
                }).padding([.bottom], self.paddingFromActionButtonToBottom)
                NavigationLink(
                    destination: MaumJournalWritingFullView(modelView: self.modelView)                           .navigationBarTitle("")
                        .navigationBarHidden(true),
                    isActive: $willMoveToWritingFullView
                ) {
                    EmptyView()
                }
            }
        }
        .frame(width: self.viewWidth , height: self.viewHeight)
        .onReceive(self.modelView.$maumJournalModel, perform: {data in
                    print("View 변경 전달")
                    print("view에서 받은 개수 : \(data.journalItemList.count)")})
        .onAppear{
            self.setUserId()
            self.modelView.connectData()
            print("요약뷰 새로 등장!")
        }
        .onDisappear{
            print("Summary View 없어짐")
            print("없어지는 순간의 개수 : \(self.modelView.maumJournalModel.journalItemList.count)")
        }
    }
}
struct SummaryGrid : View{
    @ObservedObject var modelView:MaumJournalModelView
//    var journalItemList : [JournalItem]
//    var journalItemListToShow :[JournalItem]{
//        // 최대 4개의 값을 쓰는 보호용임. 실제로 어떤 4개를 노출할지의 Sorting은 modelView에서 알려주는 대로
//        return Array(journalItemList[..<4])
//    }
    var additionalItemCount : Int{
        return max(4 - self.modelView.maumJournalModel.journalItemList.count,0)
    }
    var body : some View{
            HStack{
                Text("\(self.modelView.maumJournalModel.journalItemList.count)")
                Spacer()
                ForEach(self.modelView.maumJournalModel.journalItemList){item in
                    SummaryEachGrid(journalItem: item, showJournalItem: true)
                    Spacer()
                }
                ForEach(0 ..< additionalItemCount, id:\.self){ i in
                    SummaryEachGrid(journalItem: nil, showJournalItem: false)
                    Spacer()
                }
            }
    .frame(width:360, height:88)
    }
}
struct SummaryEachGrid: View{
    var journalItem : JournalItem?
    var showJournalItem : Bool = false
    let gridWidth : CGFloat = 64
    let gridHeight : CGFloat =  88
    let fontSetting : FontSetting = FontSetting(fontWeight: .regular, fontSize: .verySmall12)
    var body : some View{
            Group{
                if self.showJournalItem == true{
                    VStack{
//TODO:- 변경 필요
                        Image("SmallCloud2")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 48, height: 48)
                        Text("4/17")
                            .adjustFont(fontSetting: fontSetting)
                    }
                }else{
                    Color.beigeWhite
                }
            }
        .frame(width: self.gridWidth, height: self.gridHeight)
    }
}

struct SummaryActionButton:View{
    var title : String
    var completion : () -> Void
    let buttonWidth : CGFloat =  338
    let buttonHeight :CGFloat = 48
    let buttonRadius :CGFloat = 10.0
    var body : some View{
        Button(action:completion){
            ZStack{
                RoundedRectangle(cornerRadius: buttonRadius).foregroundColor(.salmon)
                Text(title).foregroundColor(.white)
            }
        }
        .shadow(radius: 10)
        .frame(width : buttonWidth, height : buttonHeight)
    }
}

//struct MaumJournalSummaryView_Previews: PreviewProvider {
//    static var previews: some View {
//        MaumJournalSummaryView()
//    }
//}