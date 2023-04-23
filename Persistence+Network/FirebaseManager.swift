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

//    func storeDiary(diaryData: Diary) async {
//        guard let uid = auth.currentUser?.uid else { return } // 유저가 접속여부인지 먼저 체크
//        do {
//            print("Data Store function called, User uid is this : \(uid)")
//
//            // 저장하려는 데이터를 딕셔너리 형태로 만듬
//            let diaryData = [
//                "id": diaryData.id,
//                "category": diaryData.category.rawValue,
//                "title": diaryData.title,
//                "text": diaryData.text,
//                "date": diaryData.date
//            ] as [String : Any]
//
//            let query = firestore
//                .collection("users")
//                .document(uid)
//                .collection("diaries")
//                .whereField("id", isEqualTo: diaryData["id"] as Any)
//
//            let querySnapshot = try await query.getDocuments()
//
//            // users 콜레션에 유저가 로그인해서 받은 uid랑 똑같은 이름의 document를 만들고,
//            // 그 안에 diaries라는 콜렉션을 만든다음, 그 콜렉션 안의 필드에서 다이어리가 가진 id와 같은 document를 찾는다.
//            //
//            // If a document with the same id exists, print an error message and return
//            if !querySnapshot.isEmpty {
//                print("A document with the same id already exists in the diaries collection.")
//                return
//            }
//
//            try await firestore.collection("users").document(uid).collection("diaries").document().setData(diaryData)
//
//        } catch {
//            print("Data Stroing error occured: \(error)")
//        }
//    }
//
//    func saveEntireData(with data: [Diary]) {
//        Task {
//            for datum in data {
//                await storeDiary(diaryData: datum)
//            }
//        }
//    }
//
//    func loadData() async -> [Diary] {
//        var diaries: [Diary] = []
//        guard let uid = auth.currentUser?.uid else { return [] }
//        let ref = firestore.collection("users").document(uid).collection("diaries")
//        do {
//            let documents = try await ref.getDocuments().documents
//            for document in documents {
//                print("document is this")
//                print(document)
//                let title = document["title"] as? String ?? ""
//                let text = document["text"] as? String ?? ""
//                let date = document["date"] as! String
//                let id = document["id"] as? String ?? ""
//                let category = document["category"] as? String ?? ""
//                var diary = Diary(category: EmotionCategory(rawValue: category)!,
//                                  title: title,
//                                  text: text,
//                                  date: date)
//                diary.id = id
//                diaries.append(diary)
//            }
//        } catch {
//            print("Data load eror: \(error)")
//        }
//        return diaries
//    }
}


