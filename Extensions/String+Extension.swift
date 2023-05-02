//
//  String+Extension.swift
//  PlantWithJ
//
//  Created by 장지수 on 2023/03/23.
//

import Foundation

extension String {
    func toWeekDayComponent() -> Int {
        switch self {
        case "Sun": return 1
        case "Mon": return 2
        case "Tue": return 3
        case "Wed": return 4
        case "Thur": return 5
        case "Fri": return 6
        case "Sat": return 7
        default: return 0
        }
    }
}

extension String {
    func toDate() -> Date? {
        // Create a DateFormatter
        let dateFormatter = DateFormatter()

        // Set the date format
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .short
//        dateFormatter.dateFormat = "MMM d, yyyy h:mm a"

        // Set the locale to the user's device locale
        dateFormatter.locale = .current

        // Attempt to parse the date string to a Date object
        return dateFormatter.date(from: self)
    }
}

