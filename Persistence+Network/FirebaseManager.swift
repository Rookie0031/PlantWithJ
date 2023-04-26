//
//  FirebaseManager.swift
//  PlantWithJ
//
//  Created by 장지수 on 2023/04/23.
//

import SwiftUI
import Firebase
import FirebaseAuth
import FirebaseStorage
import FirebaseFirestore

final class FirebaseManager: NSObject {
    
    static let shared = FirebaseManager()
    
    private var cachedImages = NSCache<NSString, NSData>()
    
    let auth: Auth
    let storage: Storage
    let firestore: Firestore
    
    override init() {
        self.auth = Auth.auth()
        self.storage = Storage.storage()
        self.firestore = Firestore.firestore()
    }
    
    func signInUser(email: String, password: String, completion: ()->Void) async -> String? {
        do {
            let data = try await auth.signIn(withEmail: email, password: password)
            print("Success LogIn")
            completion()
            return data.user.uid
        } catch {
            print("Failed to LogIn")
            return nil
        }
    }
    
    func createNewAccount(email: String, password: String, completion: ()->Void) async {
        do {
            try await auth.createUser(withEmail: email, password: password)
            print("Successfully created user")
            completion()
        } catch {
            print("Failed to create user")
            print("The error message is this \(error)")
        }
    }
    
    func deleteAccount() async {
        do {
            try await auth.currentUser?.delete()
        } catch {
            print("Failed to disconnect friend")
        }
    }
    
    func getUser() async -> User? {
        guard let uid = auth.currentUser?.uid else { return nil }
        do {
            let user = try await firestore.collection("users").document(uid).getDocument(as: User.self)
            print("Success get user")
            return user
        } catch {
            print("Get User error")
            return nil
        }
    }
    
    func getUserWithId(id: String) async -> User? {
        do {
            let user = try await firestore.collection("users").document(id).getDocument(as: User.self)
            print("Success get user")
            return user
        } catch {
            print("Get User error")
            return nil
        }
    }
    
    func signOut() async {
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
            print("Singout is done")
            
        } catch let signOutError as NSError {
            print("Error signing out: %@", signOutError)
        }
    }
    
    func addPlantProfile(with data: PlantInformationModel) async {
        guard let uid = auth.currentUser?.uid else { return } // 유저가 접속여부인지 먼저 체크
        do {
            print("Data Store function called, User uid is this : \(uid)")
            guard let profileImageData = UIImage(data: data.imageData)?.jpegData(compressionQuality: 0.3) else { return }
            
            // Create a root reference
            let storageRef = storage.reference()

            // Create a reference to the file you want to upload
            let plantProfileRef = storageRef.child("images/\(UUID().uuidString).jpg")
            
            let result = try await plantProfileRef.putDataAsync(profileImageData, metadata: nil)
            print("PlandProfile Image Upload result: \(result)")
            
            let plantProfileURL = try await plantProfileRef.downloadURL().absoluteString
            
            // 저장하려는 데이터를 딕셔너리 형태로 만듬
            let plantProfile = [
                "id": data.id,
                "name": data.name,
                "profileImageURL": plantProfileURL,
                "species": data.species,
                "birthday": data.birthDay.formatted(date: .abbreviated, time: .shortened)
            ] as [String : Any]
            
            try await firestore.collection("user").document(uid).collection("Plants").document(data.id).setData(plantProfile)
            
            for datum in data.wateringDay {
                let dateInfo = datum.dateInfo.formatted(date: .abbreviated, time: .shortened)
                let dayText = datum.dayText
                
                let wateringDay = [
                    "dateInfo": dateInfo,
                    "dayText": dayText,
                ] as [String : Any]
                
                try await firestore.collection("user").document(uid).collection("Plants").document(data.id).collection("WateringDays").document(data.id).setData(wateringDay)
            }
        } catch {
            print("Data Stroing error occured: \(error)")
        }
    }
    
    func editPlantProfile(with data: PlantInformationModel) async {
        guard let uid = auth.currentUser?.uid else { return } // 유저가 접속여부인지 먼저 체크
        do {
            print("Data Store function called, User uid is this : \(uid)")
            guard let profileImageData = UIImage(data: data.imageData)?.jpegData(compressionQuality: 0.3) else { return }
            
            // Create a root reference
            let storageRef = storage.reference()

            // Create a reference to the file you want to upload
            let plantProfileRef = storageRef.child("images/\(UUID().uuidString).jpg")
            
            let result = try await plantProfileRef.putDataAsync(profileImageData, metadata: nil)
            print("PlandProfile Image Upload result: \(result)")
            
            let plantProfileURL = try await plantProfileRef.downloadURL().absoluteString
            
            // 저장하려는 데이터를 딕셔너리 형태로 만듬
            let plantProfile = [
                "id": data.id,
                "name": data.name,
                "profileImageURL": plantProfileURL,
                "species": data.species,
                "birthday": data.birthDay.formatted(date: .abbreviated, time: .shortened)
            ] as [String : Any]
            
            try await firestore.collection("user").document(uid).collection("Plants").document(data.id).updateData(plantProfile)
            
            for datum in data.wateringDay {
                let dateInfo = datum.dateInfo.formatted(date: .abbreviated, time: .shortened)
                let dayText = datum.dayText
                
                let wateringDay = [
                    "dateInfo": dateInfo,
                    "dayText": dayText,
                ] as [String : Any]
                
                try await firestore.collection("user").document(uid).collection("Plants").document(data.id).collection("WateringDays").document(data.id).updateData(wateringDay)
            }
        } catch {
            print("Data Stroing error occured: \(error)")
        }
    }
    
    func addPlantDiary(with data: DiaryDataModel, plantId: String) async {
        guard let uid = auth.currentUser?.uid else { return } // 유저가 접속여부인지 먼저 체크
        do {
            print("Diary Store function called, User uid is this : \(uid)")
            guard let diaryPic = UIImage(data: data.image)?.jpegData(compressionQuality: 0.3) else { return }
            
            // Create a root reference
            let storageRef = storage.reference()
            
            // Create a reference to the file you want to upload
            let plantProfileRef = storageRef.child("images/\(UUID().uuidString).jpg")
            
            // Image Upload
            _ = try await plantProfileRef.putDataAsync(diaryPic, metadata: nil)
            
            let plantProfileURL = try await plantProfileRef.downloadURL().absoluteString
            
            // 저장하려는 데이터를 딕셔너리 형태로 만듬
            let plantDiary = [
                "id": data.id,
                "diaryTitle": data.diaryTitle,
                "diaryPicture": plantProfileURL,
                "diaryText": data.diaryText,
                "diaryDate": data.date.formatted(date: .abbreviated, time: .shortened)
            ] as [String : Any]
            
            try await firestore.collection("user").document(uid).collection("Plants").document(plantId).collection("Diary").document(data.id).setData(plantDiary)
            
        } catch {
            print("Data Stroing error occured: \(error)")
        }
    }
    
    func loadData() async -> [PlantInformationModel] {
        var dataSet: [PlantInformationModel] = []
        guard let uid = auth.currentUser?.uid else { return [] }
        
        let ref = firestore.collection("user").document(uid).collection("Plants")
        
        do {
            let documents = try await ref.getDocuments().documents
            for document in documents {
                let birthdayString = document["birthday"] as? String ?? ""
                let plantId = document["id"] as? String ?? ""
                let species = document["species"] as! String
                let name = document["name"] as? String ?? ""
                let profileURL = document["profileImageURL"] as? String ?? ""
                var wateringDays: [WateringDay] = []
                var diaries: [DiaryDataModel] = []
                
                let profileImageData = try await fetchOneImage(withURL: profileURL)
                let birdayDate = birthdayString.toDate() ?? Date()
                
                let wateringDaysDoc = try await document.reference.collection("WateringDays").getDocuments().documents
                
                for wateringDayDoc in wateringDaysDoc {
                    let dayText = wateringDayDoc["dayText"] as? String ?? ""
                    let dateInfo = wateringDayDoc["dateInfo"] as? String ?? ""
                    let wateringDate = dateInfo.toDate() ?? Date()
                    
                    let wateringDay = WateringDay(dayText: dayText, dateInfo: wateringDate)
                    wateringDays.append(wateringDay)
                }
                
                let diaryDocs = try await document.reference.collection("Diary").getDocuments().documents
                
                if !diaryDocs.isEmpty {
                    for diaryDoc in diaryDocs {
                        let id = diaryDoc["id"] as? String ?? ""
                        let dateString = diaryDoc["diaryDate"] as? String ?? ""
                        let date = dateString.toDate() ?? Date()
                        let diaryTitle = diaryDoc["diaryTitle"] as? String ?? ""
                        let diaryText = diaryDoc["diaryText"] as? String ?? ""
                        let imageURL = diaryDoc["diaryPicture"] as? String ?? ""
                        let imageData = try await fetchOneImage(withURL: imageURL)
                        
                        let diary = DiaryDataModel(id: id, date: date, image: imageData, diaryText: diaryText, diaryTitle: diaryTitle)
                        diaries.append(diary)
                    }
                }
                let plantInfo = PlantInformationModel(id: plantId, imageData: profileImageData, name: name, species: species, birthDay: birdayDate, wateringDay: wateringDays, diary: diaries)
                dataSet.append(plantInfo)
            }
        } catch {
            print("Data load error: \(error)")
        }
        return dataSet
    }
    
    func fetchOneImage(withURL url: String) async throws -> Data {
        var imageData = Data()
        do {
            if let cachedImage = cachedImages.object(forKey: url as NSString) {
                let cachedimageData = cachedImage as Data
                return cachedimageData
                
            } else {
                guard let imageRequestURL = URL(string: url) else { return Data() }
                async let (data, urlResponse) = URLSession.shared.data(from: imageRequestURL)
                try await self.cachedImages.setObject(data as NSData, forKey: url as NSString)
                let httpResponse = try await urlResponse as! HTTPURLResponse
                if !(200...299).contains(httpResponse.statusCode) {
                    print("bad status code: \(httpResponse.statusCode)")
                }
                imageData = try await data
            }
        } catch {
            print("Image fetch error: \(error)")
        }
        return imageData
    }

}


