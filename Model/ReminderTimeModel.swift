//
//  ReminderTimeModel.swift
//  PlantWithJ
//
//  Created by 장지수 on 2023/03/09.
//

import Foundation

struct ReminderTimeModel: Identifiable {
    let id: String = UUID().uuidString
    let day: String
    var isSelected: Bool = false
    var time: Date
}
