//
//  PlantInformationModel.swift
//  PlantWithJ
//
//  Created by 장지수 on 2023/03/11.
//

import Foundation

struct PlantInformationModel: Hashable, Identifiable, Codable {
    var id: String = UUID().uuidString
    let imageData: Data
    let name: String
    let species: String
    let birthDay: Date
    let wateringDay: [Date]
    let diary: [DiaryDataModel]
}
