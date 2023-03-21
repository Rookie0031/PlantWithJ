//
//  Date+Extension.swift
//  PlantWithJ
//
//  Created by 장지수 on 2023/03/11.
//

import Foundation

extension Date {
    func weekday() -> String {
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
    
    func hourAndminute() -> String {
        let calendar = Calendar.current
        let hour = String(calendar.component(.hour, from: self))  // extract the hour component
        let minute = String(calendar.component(.minute, from: self))
        return hour+":"+minute
    }
    
    func year() -> Int {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year], from: self)
        return components.year ?? 0
    }
    
    func month() -> Int {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.month], from: self)
        return components.month ?? 0
    }
    
    func day() -> Int {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.day], from: self)
        return components.day ?? 0
    }
    
    func toBirthDayString() -> String {
        let month = String(self.month())
        let day = String(self.day())
        let year = String(self.year())
        return month+"/"+day+"/"+year
    }
}
