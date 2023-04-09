//
//  FirebaseManager.swift
//  PlantWithJ
//
//  Created by 장지수 on 2023/04/09.
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
    
    func signInUser(email: String, password: String) async -> String? {
        do {
            let data = try await auth.signIn(withEmail: email, password: password)
            print("Success LogIn")
            return data.user.uid
        } catch {
            print("Failed to LogIn")
            return nil
        }
    }
    
    func createNewAccount(email: String, password: String) async {
        do {
            try await auth.createUser(withEmail: email, password: password)
            print("Successfully created user")
        } catch {
            print("Failed to create user")
        }
    }
    
    func deleteAccount() async {
        do {
            try await auth.currentUser?.delete()
        } catch {
            print("Failed to delete Account")
        }
    }
    
    func storeUserInformation(email: String, name: String, profileImage: UIImage, isArtist: Bool) async {
        guard let uid = auth.currentUser?.uid else { return }
        do {
            let ref = storage.reference(withPath: uid)
            guard let imageData = profileImage.jpegData(compressionQuality: 0.5) else { return }
            
            let result = try await ref.putDataAsync(imageData, metadata: nil)
            print(result)
            
            let profileImageUrl = try await ref.downloadURL().absoluteString
            let appDelegate = await UIApplication.shared.delegate as! AppDelegate
            let userToken = ""
            let userData = ["email": email, "uid": uid, "name": name, "profileImageUrl": profileImageUrl, "token": userToken, "isArtist": isArtist] as [String : Any]
            try await firestore.collection("users").document(uid).setData(userData)
        } catch {
            print("Store User error")
        }
    }
}

