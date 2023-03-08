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
    let time: Date
}
