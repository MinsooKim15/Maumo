//
//  StartVerticalServiceView.swift
//  Maumo
//
//  Created by minsoo kim on 2021/06/18.
//

import SwiftUI

struct StartVerticalServiceView: View {
    var currentReplyMessageData:MessageData
    var failCompletion:()->Void
    var successCompletion:()->Void
    var computedView:AnyView{
        switch(self.currentReplyMessageData.startVerticalService?.verticalServiceId){
        case .JournalService_MaumDiary:
            return AnyView(MaumJournalWritingFullView(modelView: MaumJournalModelView()))
        case .none:
            return AnyView(MaumJournalWritingFullView(modelView: MaumJournalModelView()))
        }
    }
    var body: some View {
        ZStack{
            computedView.clipShape(RoundedRectangle(cornerRadius: 10.0))
            VStack{
                HStack{
                    Spacer()
                    CloseButton(closeClosure: {failCompletion()})
                    Spacer().frame(width:20)
                }.padding([.top],20)
                Spacer()
            }
        }
        .frame(width:340, height:640)
    }
}

struct StartVerticalServiceView_Previews: PreviewProvider {
    static var previews: some View {
        StartVerticalServiceView(currentReplyMessageData: MessageData(startVerticalService: StartVerticalService(buttonTitle: "마음일기 쓰기", verticalServiceId: .JournalService_MaumDiary, actionId: .StartWriting)), failCompletion: {print("YEAH")}, successCompletion: {print("YEAH")})
    }
}
