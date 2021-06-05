//
//  DateUtil.swift
//  Maumo
//
//  Created by minsoo kim on 2021/06/05.
//

import Foundation

struct DateUtil{
    static func getWeekDayInKorean(of weekDay:Int,inFull:Bool)->String{
        var dayString = ""
        switch(weekDay){
        case 1:
            dayString = "일"
        case 2:
            dayString = "화"
        case 3:
            dayString = "수"
        case 4:
            dayString = "목"
        case 5:
            dayString = "금"
        case 6:
            dayString = "토"
        case 7:
            dayString = "일"
        default:
            dayString = "일"
        }
        if inFull{
            dayString = dayString + "요일"
        }
        return dayString
    }
}
