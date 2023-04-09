//
//  FileManager.swift
//  PlantWithJ
//
//  Created by 장지수 on 2023/03/17.
//

import SwiftUI
import FirebaseStorage
import Foundation

final class PlantDataStorage: ObservableObject {
    private let storage = Storage.storage()
    private let storageRef = Storage.storage().reference()
    
    @Published var plantData: [PlantInformationModel] = []

    private static func fileURL() throws -> URL {
        try FileManager.default.url(for: .documentDirectory,
                                    in: .userDomainMask,
                                    appropriateFor: nil,
                                    create: false)
        .appendingPathComponent("Plants.data")
    }
    
    static func loadLocalData(completion: @escaping (Result<[PlantInformationModel], Error>)->Void) {
        DispatchQueue.global(qos: .background).async {
            do {
                // Because data doesn’t exist when a user launches the app for the first time, you call the completion handler with an empty array if there’s an error opening the file handle.
                let fileURL = try fileURL()
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
//MARK: Firebase
extension PlantDataStorage {
    func uploadSinglePlantData(_ plantInfo: PlantInformationModel, completion: @escaping (Error?) -> Void) {
        let imageRef = storageRef.child("images/\(plantInfo.id).jpg")
        guard let imageData = UIImage(data: plantInfo.imageData)?.jpegData(compressionQuality: 0.4) else {
            completion(NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Error converting image data to JPEG format"]))
            return
        }
        
        let metaData = StorageMetadata()
        metaData.contentType = "image/jpeg"
        
        imageRef.putData(imageData, metadata: metaData) { (metaData, error) in
            if let error = error {
                completion(error)
                return
            }
            
            let plantInfoRef = self.storageRef.child("plantData/\(plantInfo.id).json")
            let encoder = JSONEncoder()
            encoder.dateEncodingStrategy = .iso8601
            do {
                let plantInfoData = try encoder.encode(plantInfo)
                plantInfoRef.putData(plantInfoData, metadata: nil) { (metaData, error) in
                    if let error = error {
                        completion(error)
                        return
                    }
                    print("Data Transfer Successful")
                }
            } catch {
                completion(error)
            }
        }
    }
}
