//
//  DataSave.swift
//  PlantWithJ
//
//  Created by 장지수 on 2023/03/25.
//

import Foundation

func saveData(with data: [PlantInformationModel]) {
    PlantDataStorage.saveLocalData(data: data) { result in
        if case .failure(let error) = result {
            fatalError(error.localizedDescription)
        }
    }
}
