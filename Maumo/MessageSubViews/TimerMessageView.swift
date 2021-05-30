//
//  TimerMessageView.swift
//  Maumo
//
//  Created by minsoo kim on 2021/01/31.
//

import SwiftUI

struct TimerMessageView: View {
    @ObservedObject var modelView: ChattingModelView
    var message: Message
    var body: some View {
        Group{
            if(!message.used){
                TimerView(modelView:modelView)
            }else{
                UsedTimerView()
            }

        }
    }
}
struct TimerView:View{
    @ObservedObject var modelView: ChattingModelView
    let timerTitleFontSetting = FontSetting(fontWeight: .bold, fontSize: .medium18)
    let timerSecondsLeftFontSetting = FontSetting(fontWeight: .bold, fontSize: .medium18)
    func finishTimerWithSuccess(){
        self.modelView.finishTimer(withSuccess:true)
    }
    func finishTimerWithFail(){
        self.modelView.finishTimer(withSuccess:false)
    }
    var body: some View{
        VStack{
            ZStack{
                Color.beigeWhite
                
                VStack(spacing:0) {
                    HStack{
                        Spacer()
                        CloseTimerButton()
                            .padding([.trailing,.top],16)
                            .onTapGesture {
                                self.finishTimerWithFail()
                            }
                    }
                    ImageView(withUrl: self.modelView.timerImage)
                        .frame(width:60, height:60)
                    Text(self.modelView.timerTitle).adjustFont(fontSetting: self.timerTitleFontSetting)
                        .padding([.top], 16)
                    Text(self.modelView.timerSecondsLeft)
                        .adjustFont(fontSetting: self.timerSecondsLeftFontSetting)
                        .padding([.top], 8)
                    Group{
                        if (modelView.timerMode == .initial)||(modelView.timerMode == .paused){
                            TimerPlayButton()
                                .onTapGesture(perform: {
                                    self.modelView.startTimer()
                                })
                        }
                        if (modelView.timerMode == .running){
                            HStack{
                                Spacer()
                                TimerPauseButton()
                                    .onTapGesture(perform: {
                                        self.modelView.pauseTimer()
                                    })
                                Spacer()
                                TimerDoneButton()
                                    .onTapGesture(perform: {
                                        self.finishTimerWithSuccess()
                                    })
                                Spacer()
                            }
                        }
                        if (modelView.timerMode == .done){
                            HStack{
                                TimerDoneButton()
                                    .onTapGesture(perform: {
                                        self.finishTimerWithSuccess()
                                    })
                            }
                        }
                    }
                    .padding([.top], 16)
                    Spacer()
                }
            }
            .frame(width:260,height:264)
            .cornerRadius(10)
            Spacer().frame(height:20)
        }

        
    }
}
struct UsedTimerView:View{
    var body : some View{
        EmptyView()
    }
}
struct TimerPlayButton:View{
    var body: some View{
        Image(systemName: "play.circle")
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: 50, height: 50)
    }
}
struct TimerPauseButton:View{
    var body: some View{
        Image(systemName: "pause.circle")
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: 50, height: 50)
    }
}
struct TimerDoneButton:View{
    var body: some View{
        Image(systemName:"checkmark.circle")
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: 50, height: 50)
    }
}
struct CloseTimerButton:View{
    var body: some View{
        ZStack{
            Circle().frame(width:28, height:28)
                .foregroundColor(.white)
            Image(systemName: "xmark")
                .font(.system(size: 10))
                .foregroundColor(.black)
        }
        .shadow(radius: 5)
    }
}
//if modelView.timerIsActive{
//    Text(modelView.chattingModel.timer.title)
//        .padding(10)
//        .foregroundColor(Color.white)
//        .background(Color.blue)
//        .cornerRadius(10)
//}else{
