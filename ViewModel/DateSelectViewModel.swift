//
//  DateSelectViewModel.swift
//  PlantWithJ
//
//  Created by 장지수 on 2023/03/09.
//

import Foundation

final class DateSelectViewModel: ObservableObject {
    @Published var remindTimes: [ReminderTimeModel] = []
}
