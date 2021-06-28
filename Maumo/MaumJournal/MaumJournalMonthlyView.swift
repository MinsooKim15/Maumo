//
//  MaumJournalMonthlyView.swift
//  Maumo
//
//  Created by minsoo kim on 2021/06/05.
//

import SwiftUI

struct MaumJournalMonthlyView: View {
    @State var choosingMonth:Bool = false
    @ObservedObject var modelView:MaumJournalModelView
    var body: some View {
        ZStack{
            Color.beigeWhite
            VStack{
                CustomNavigationBar(hasTitleText: false, titleText: "",backgroundColor: .beigeWhite)
                JournalGridView(modelView: self.modelView)
                Spacer()
            }
        }.onAppear{
            self.modelView.connectData()
        }
    }
}

struct JournalGridView:View{
    @ObservedObject var modelView:MaumJournalModelView
    let totalRowCount = 6
    let totalColumnCount = 5
    var rowViewHeight:CGFloat = 70
    var firstEmptyRowCount:Int{
        let counter = (self.modelView.maumJournalModel.journalItemList.count / totalColumnCount)+1
        print(counter)
        return counter
    }
    var lastEmptyRowCount:Int{
        let counter = totalColumnCount - firstEmptyRowCount
        if counter < 0{
            return 0
        }else{
            return counter
        }
    }
    let frameHeight: CGFloat = 500
    
    var body: some View{
        VStack{
            ForEach(0..<firstEmptyRowCount){counter in
                JournalGridRowView(modelView: self.modelView, journalList: self.modelView.getSplitedJournalList(of: counter, interval: self.totalColumnCount, lastIndex: firstEmptyRowCount), totalColumnCount: self.totalColumnCount).frame(height:self.rowViewHeight)
            }
            ForEach(0..<lastEmptyRowCount){counter in
                Rectangle().foregroundColor(.beigeWhite).frame(height:self.rowViewHeight)
            }
        }.frame(height: self.frameHeight)
    }
}
struct JournalGridRowView:View{
    @ObservedObject var modelView:MaumJournalModelView
    @State var willMoveToWritingFullView:Bool = false
    var journalList: [JournalItem]
    var totalColumnCount:Int
    let itemHeight:CGFloat = 60
    let itemWidth:CGFloat = 60
    var emptyCount:Int{
        let counter = self.totalColumnCount - self.journalList.count
        if counter < 0{
            return 0
        }else{
            return counter
        }
    }
    var body: some View{
        HStack{
            ForEach(self.journalList){item in
                JournalGridItemView(feelingEnum: item.feeling, date: item.targetDatetime).frame(width: self.itemWidth, height:self.itemHeight).onTapGesture {
                    
                    self.modelView.startEditing(with: item)
                    self.willMoveToWritingFullView = true
                }
            }
            ForEach(0..<self.emptyCount){_ in
                Rectangle().foregroundColor(.beigeWhite).frame(width: self.itemWidth, height:self.itemHeight)
            }
            NavigationLink(
                destination: MaumJournalWritingFullView(modelView: self.modelView)
                    .navigationBarTitle("")
                    .navigationBarHidden(true),
                isActive: $willMoveToWritingFullView,
                label: {
                    EmptyView()
            })
        }
    }
}
struct JournalGridItemView:View{
    var feelingEnum:MaumJournalFeelingEnum
    let fontSetting:FontSetting = FontSetting(fontWeight: .regular, fontSize: .small14)
    let imageWidth:CGFloat = 48
    let imageHeight:CGFloat = 40
    var date:Date
    var dateInString:String{
        let cal = Calendar(identifier: .gregorian)
        let comps = cal.dateComponents([.day], from: self.date)
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "MM-dd D"
//        dateFormatter.string(from: self.date)
        return "\(comps.day!)"
    }
    var body: some View{
        VStack(alignment:.center){
            Image(self.feelingEnum.rawValue)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width:self.imageWidth, height: self.imageHeight)
            Text(dateInString)
                .adjustFont(fontSetting: self.fontSetting)
        }
    }
}

