//
//  TimerMessageView.swift
//  Maumo
//
//  Created by minsoo kim on 2021/01/31.
//

import SwiftUI

struct TimerMessageView: View {
    @ObservedObject var modelView: MainModelView
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
    @ObservedObject var modelView: MainModelView
    func finishTimerWithSuccess(){
        self.modelView.finishTimer(withSuccess:true)
    }
    var body: some View{
        VStack {
            Text(secondsToMinutesAndSeconds(seconds: modelView.timerSecondsLeft))
                .font(.system(size: 80))
                .padding(.top, 80)
            Image(systemName: modelView.timerMode == .running ? "pause.circle.fill" : "play.circle.fill")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 180, height: 180)
                .foregroundColor(.red)
                .onTapGesture(perform: {
                    self.modelView.timerMode == .running ? self.modelView.pauseTimer() : self.modelView.startTimer()
                })
            if modelView.timerMode == .paused {
                Image(systemName: "gobackward")
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 50, height: 50)
                    .padding(.top, 40)
                .onTapGesture(perform: {
                    self.modelView.resetTimer()
                })
            }
            Text("타이머 종료하기").onTapGesture(perform:{
                self.finishTimerWithSuccess()
            })
           
            Spacer()
        }
    }
}
struct UsedTimerView:View{
    var body : some View{
        Text("지나간 Timer")
            .padding(10)
            .foregroundColor(Color.white)
            .background(Color.blue)
            .cornerRadius(10)    }
}
//if modelView.timerIsActive{
//    Text(modelView.chattingModel.timer.title)
//        .padding(10)
//        .foregroundColor(Color.white)
//        .background(Color.blue)
//        .cornerRadius(10)
//}else{
