//
//  PlantInformationModel.swift
//  PlantWithJ
//
//  Created by 장지수 on 2023/03/11.
//

import Foundation

struct PlantInformationModel {
    let imageData: Data
    let name: String
    let species:String
    let birthDay: Date
    let wateringDay: [Date]
}
