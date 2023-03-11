//
//  Date+Extension.swift
//  PlantWithJ
//
//  Created by 장지수 on 2023/03/11.
//

import Foundation

extension Date {
    func toDay() -> String {
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
    
    func toHourAndMinute() -> String {
        let calendar = Calendar.current
        let hour = String(calendar.component(.hour, from: self))  // extract the hour component
        let minute = String(calendar.component(.minute, from: self))
        return hour+":"+minute
    }
}
