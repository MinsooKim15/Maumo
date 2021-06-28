//
//  Date+Distance.swift
//  Maumo
//
//  Created by minsoo kim on 2021/06/14.
//

import Foundation
extension Date {

    func fullDistance(from date: Date, resultIn component: Calendar.Component, calendar: Calendar = .current) -> Int? {
        calendar.dateComponents([component], from: self, to: date).value(for: component)
    }

    func distance(from date: Date, only component: Calendar.Component, calendar: Calendar = .current) -> Int {
        let days1 = calendar.component(component, from: self)
        let days2 = calendar.component(component, from: date)
        return days1 - days2
    }

    func hasSame(_ component: Calendar.Component, as date: Date) -> Bool {
        distance(from: date, only: component) == 0
    }
    func isSameDay(with date:Date)->Bool{
        if self.distance(from: date, only: .day) == 0{
            if self.distance(from: date, only: .month) == 0, self.distance(from: date, only: .year) == 0{
                return true
            }
        }
        return false
    }
}
