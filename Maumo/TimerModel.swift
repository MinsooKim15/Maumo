//
//  TimerModel.swift
//  Maumo
//
//  Created by minsoo kim on 2021/01/31.
//

import Foundation
struct TimerModel{
    var timerMode: TimerMode = .initial
    var time : Int = 0
    var isActive: Bool = false
    var title : String = ""
    var imageUrl : String = ""
    var successPostback : PostbackPayload?
    var failPostback : PostbackPayload?
    var used : Bool = false
    var message : Message?
    // 이 Timer를 invoke 시킨 메시지 -> 나중에 messages에서 찾기 위함
    var currentInvokedTimerMessage : Message?
    var secondsLeft = UserDefaults.standard.integer(forKey: "timerLength")
    var timer = Timer()
    init(){
        timerMode = .initial
        time  = 0
        isActive = false
        title = ""
        imageUrl = ""
        used = false
    }
    mutating func setTimer(message:Message){
        if let timerData = message.data.timer{
            self.time = timerData.time
            self.isActive = true
            self.title = timerData.title
            self.imageUrl = timerData.imageUrl
            self.successPostback = timerData.successPostback
            self.failPostback = timerData.failPostback
            let defaults = UserDefaults.standard
            defaults.set(timerData.time, forKey: "timerLength")
            self.secondsLeft = timerData.time
            self.timerMode = .initial
            self.used = timerData.used
            self.message = message
        }
    }
//    func startTimer(){
//        print("Start Timer")
//        self.timerMode = .running
//
//        self.timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true, block: { _ in
//            print(self.secondsLeft)
//            if self.secondsLeft == 0 {
//                self.resetTimer()
//            }
//            self.secondsLeft -= 1
//        })
//    }
    mutating func resetTimer(){
        self.timerMode = .initial
        self.timer.invalidate()
    }
    mutating func pauseTimer(){
        self.timerMode = .paused
        self.timer.invalidate()
    }
    mutating func endTimer(){
        self.timerMode = .done
        self.timer.invalidate()
    }
    mutating func finishTimer(){
        self.isActive = false
    }
    func getPostback(withSuccess:Bool)->PostbackPayload{
        if withSuccess{
            return self.successPostback!
        }else{
            return self.failPostback!
        }
    }
    
}
