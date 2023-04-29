//
//  FileManager.swift
//  PlantWithJ
//
//  Created by 장지수 on 2023/03/17.
//

import SwiftUI
import Foundation

final class PlantDataStorage: ObservableObject {
    var userId: String = ""
    @Published var isLoggedIn: Bool = false
    @Published var isDataFirstLoaded: Bool = false
    @Published var plantData: [PlantInformationModel] = []
    

    private static func fileURL() throws -> URL {
        try FileManager.default.url(for: .documentDirectory,
                                    in: .userDomainMask,
                                    appropriateFor: nil,
                                    create: false)
        .appendingPathComponent("Plants.data")
    }
    
    func addPlantInfo(with data: PlantInformationModel) {
        plantData.append(data)
    }
    
    static func loadLocalData(completion: @escaping (Result<[PlantInformationModel], Error>)->Void) {
        DispatchQueue.global(qos: .background).async {
            do {
                let fileURL = try fileURL()
                print("This is fileURL: \(fileURL)")
                guard let file = try? FileHandle(forReadingFrom: fileURL) else {
                    DispatchQueue.main.async {
                        completion(.success([]))
                    }
                    return
                }
                let plantsData = try JSONDecoder().decode([PlantInformationModel].self, from: file.availableData)
                DispatchQueue.main.async {
                    completion(.success(plantsData))
                }
            } catch {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }
    }

    static func saveLocalData(data: [PlantInformationModel], completion: @escaping (Result<Int, Error>)->Void) {
        DispatchQueue.global(qos: .background).async {
            do {
                print("최종 저장전 확인")
                let plantsData = try JSONEncoder().encode(data)
                let outfile = try fileURL()
                try plantsData.write(to: outfile)
                print("저장이 성공햇어요!")
                DispatchQueue.main.async {
                    completion(.success(plantsData.count))
                }
            } catch {
                print("저장 실패")
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }
    }
}

