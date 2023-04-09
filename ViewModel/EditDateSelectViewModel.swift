//
//  EditDateSelectViewModel.swift
//  PlantWithJ
//
//  Created by 장지수 on 2023/03/22.
//

import Foundation

final class EditDateSelectViewModel: ObservableObject {
    @Published var selectedRemindTimes: [ReminderTimeModel] = []
    @Published var remindTimes: [ReminderTimeModel] = [
        ReminderTimeModel(day: "Mon", time: Date()),
        ReminderTimeModel(day: "Tue", time: Date()),
        ReminderTimeModel(day: "Wed", time: Date()),
        ReminderTimeModel(day: "Thur", time: Date()),
        ReminderTimeModel(day: "Fri", time: Date()),
        ReminderTimeModel(day: "Sat", time: Date()),
        ReminderTimeModel(day: "Sun", time: Date())
    ]
}
