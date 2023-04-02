//
//  PlantData+Extension.swift
//  PlantWithJ
//
//  Created by 장지수 on 2023/04/02.
//

import Foundation

extension Array where Element == PlantInformationModel {
    func specifiedPlant(with id: String) -> PlantInformationModel {
        let specifiedData = self.first { $0.id == id }!
        return specifiedData
    }
    
    func indexOfPlant(with id: String) -> Self.Index {
        let index = firstIndex(where: { $0.id == id })!
        return index
    }
}
