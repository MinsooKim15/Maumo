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
    @State var willMoveToMonthlyView = false
    
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
                Group{
                    Spacer()
                    SummaryGrid(modelView:self.modelView)
                    Spacer()
                }
                .onTapGesture {
                    self.willMoveToMonthlyView = true
                }
                SummaryActionButton(title:"마음 일기 쓰기", completion: {
                    self.modelView.startNewEditing()
                    self.willMoveToWritingFullView = true
                }).padding([.bottom], self.paddingFromActionButtonToBottom)
                NavigationLink(
                    destination: MaumJournalWritingFullView(modelView: self.modelView)                           .navigationBarTitle("")
                        .navigationBarHidden(true),
                    isActive: $willMoveToWritingFullView
                ) {
                    EmptyView()
                }
                NavigationLink(
                    destination: MaumJournalWritingFullView(modelView: self.modelView)                           .navigationBarTitle("")
                        .navigationBarHidden(true),
                    isActive: $willMoveToWritingFullView
                ) {
                    EmptyView()
                }
                NavigationLink(
                    destination:MaumJournalMonthlyView(modelView: self.modelView)
                        .navigationBarTitle("")
                        .navigationBarHidden(true),
                    isActive: $willMoveToMonthlyView
                ) {
                    EmptyView()
                }
            }
        }
        .frame(width: self.viewWidth , height: self.viewHeight)
        .onAppear{
            self.setUserId()
            self.modelView.connectData()
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
        return max(4 - self.modelView.maumJournalModel.journalItemListInSummary.count,0)
    }
    var body : some View{
            HStack{
                Spacer()
                ForEach(self.modelView.maumJournalModel.journalItemListInSummary){item in
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
                        Image(self.journalItem?.feeling.rawValue ?? "")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 48, height: 48)
                        Text(self.journalItem?.targetDate(month: true, day: true, weekDay: false) ?? "")
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
