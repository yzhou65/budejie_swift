//
//  Date+ADExtension.swift
//  budejie_swift
//
//  Created by Yue Zhou on 3/6/18.
//  Copyright © 2018 Yue Zhou. All rights reserved.
//

import Foundation

extension Date {
    
    func timeElapsed(from date: Date) -> DateComponents {
        let calendar = Calendar.current
        return calendar.dateComponents(Set<Calendar.Component>(arrayLiteral: Calendar.Component.year, Calendar.Component.month, Calendar.Component.day, Calendar.Component.hour, Calendar.Component.minute, Calendar.Component.second), from: date, to: self)
    }
    
    func isThisYear() -> Bool {
        let calendar = Calendar.current
        let curYear = calendar.component(Calendar.Component.year, from: Date())
        let selfYear = calendar.component(Calendar.Component.year, from: self)
        return curYear == selfYear
    }
    
    func isToday() -> Bool {
        let fmt = DateFormatter()
        fmt.dateFormat = "yyyy-MM-dd"
        let nowDate = fmt.string(from: Date())
        let selfDate = fmt.string(from: self)
        return nowDate == selfDate
    }
    
    func isThisHour() -> Bool {
        let comps = Date().timeElapsed(from: self)
        return comps.hour! < 1
    }
    
    func isYesterday() -> Bool {
        let fmt = DateFormatter()
        fmt.dateFormat = "yyyy-MM-dd"
        let nowDate = fmt.date(from: fmt.string(from: Date()))
        let selfDate = fmt.date(from: fmt.string(from: self))
        let comps = Calendar.current.dateComponents(Set<Calendar.Component>(arrayLiteral: Calendar.Component.year, Calendar.Component.month, Calendar.Component.day), from: selfDate!, to: nowDate!)
        return comps.year == 0 && comps.month == 0 && comps.day == 1
    }
}
