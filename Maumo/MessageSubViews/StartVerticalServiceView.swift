//
//  StartVerticalServiceView.swift
//  Maumo
//
//  Created by minsoo kim on 2021/06/18.
//

import SwiftUI

struct StartVerticalServiceView: View {
//    이건 그냥 개별 View를 띄우고, 필요한 Completion을 수행하는데 쓰이는 View임.
    @EnvironmentObject var session:SessionStore
    @ObservedObject var modelView: ChattingModelView
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    func failCompletion()->Void{
        self.modelView.verticalServiceFailCompletion()
        presentationMode.wrappedValue.dismiss()
    }
    func successCompletion()->Void{
        self.modelView.verticalServiceSuccessCompletion()
        presentationMode.wrappedValue.dismiss()
    }
    var computedView:AnyView{
        switch(self.modelView.chattingModel.currentReplyMessage?.data.startVerticalService?.verticalServiceId){
        case .JournalService_MaumDiary:
            return AnyView(MaumJournalWritingFullView(modelView: MaumJournalModelView(userId: self.session.session?.uid),showInCard: true,successCompletion: {successCompletion()}))
        case .none:
            return AnyView(MaumJournalWritingFullView(modelView: MaumJournalModelView(userId:self.session.session?.uid),showInCard: true,successCompletion: {successCompletion()}))
        }
    }
    var body: some View {
        ZStack{
            computedView
                VStack{
                    HStack{
                        Spacer()
                        CloseButton(closeClosure: {failCompletion()})
                        Spacer().frame(width:20)
                    }.padding([.top],20)
                    Spacer()
                }
        }
        }
}

//struct StartVerticalServiceView_Previews: PreviewProvider {
//    static var previews: some View {
//        StartVerticalServiceView(currentReplyMessageData: MessageData(startVerticalService: StartVerticalService(buttonTitle: "마음일기 쓰기", verticalServiceId: .JournalService_MaumDiary, actionId: .StartWriting)), failCompletion: {print("YEAH")}, successCompletion: {print("YEAH")}).environmentObject(SessionStore())
//    }
//}
