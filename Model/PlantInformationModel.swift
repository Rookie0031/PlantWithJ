//
//  PlantInformationModel.swift
//  PlantWithJ
//
//  Created by 장지수 on 2023/03/11.
//

import Foundation

struct PlantInformationModel: Hashable, Identifiable, Codable {
    var id: String = UUID().uuidString
    var imageData: Data
    var name: String
    var species: String
    var birthDay: Date
    var wateringDay: [WateringDay]
    var diary: [DiaryDataModel]
}

struct WateringDay: Hashable, Codable {
    var dayText: String
    var dateInfo: Date
}
