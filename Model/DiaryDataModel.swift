//
//  DiaryDataModel.swift
//  PlantWithJ
//
//  Created by 장지수 on 2023/03/17.
//

import Foundation

struct DiaryDataModel: Identifiable, Hashable {
    let id: String = UUID().uuidString
    let date: Date
    let image: Data
    let diaryText: String
}
