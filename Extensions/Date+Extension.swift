//
//  Date+Extension.swift
//  PlantWithJ
//
//  Created by 장지수 on 2023/03/11.
//

import Foundation

extension Date {
    func weekdayText() -> String {
        let calendar = Calendar.current
        let day = calendar.component(.weekday, from: self)  // extract the day component
        switch day {
        case 1: return "Sun"
        case 2: return "Mon"
        case 3: return "Tue"
        case 4: return "Wed"
        case 5: return "Thur"
        case 6: return "Fri"
        case 7: return "Sat"
        default: return "Error"
        }
    }
    
    func hourAndminuteText() -> String {
        let calendar = Calendar.current
        let hour = String(calendar.component(.hour, from: self))  // extract the hour component
        let minute = String(calendar.component(.minute, from: self))
        return hour+":"+minute
    }
    
    func yearText() -> Int {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year], from: self)
        return components.year ?? 0
    }
    
    func monthText() -> Int {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.month], from: self)
        return components.month ?? 0
    }
    
    func dayText() -> Int {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.day], from: self)
        return components.day ?? 0
    }
    
    func toBirthDayStringText() -> String {
        let month = String(self.monthText())
        let day = String(self.dayText())
        let year = String(self.yearText())
        return month+"/"+day+"/"+year
    }
}

extension Date {
    func weekday() -> Int {
        let calendar = Calendar.current
        let day = calendar.component(.weekday, from: self)  // extract the day component
        return day
    }
    
    func hourAndminute() -> (hour: Int, minute: Int) {
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: self)  // extract the hour component
        let minute = calendar.component(.minute, from: self)
        return (hour, minute)
    }
    
    func remindDateForm(weekday: Int, hourAndMinute: (hour: Int, minute: Int)) -> Date? {
        let calendar = Calendar.current
        let weekday = weekday
        let hourAndMinute = hourAndMinute
        
        var components = DateComponents()
        components.weekday = weekday
        components.hour = hourAndMinute.hour
        components.minute = hourAndMinute.minute
        
        return calendar.date(from: components)
    }
}

