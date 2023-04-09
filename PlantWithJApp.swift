//
//  PlantWithJApp.swift
//  PlantWithJ
//
//  Created by 장지수 on 2023/03/07.
//
import Foundation
import FirebaseCore
import SwiftUI

class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
      FirebaseApp.configure()
    return true
  }
}

@main
struct PlantWithJApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @StateObject private var dataStorage = PlantDataStorage()
    let launchedBefore = UserDefaults.standard.bool(forKey: "launchedBefore")
    
    var body: some Scene {
        WindowGroup {
//            SignUpView()
//                .environmentObject(dataStorage)
            if launchedBefore {
                NavigationStack {
                    MyPlantView()
                        .environmentObject(dataStorage)
                }
                .onAppear {
                    PlantDataStorage.loadLocalData { result in
                        switch result {
                        case .failure(let error):
                            print("Data Load Error: \(error)")
                        case .success(let plantData):
                            dataStorage.plantData = plantData
                            MusicPlayer.shared.startBackgroundMusic()
                        }
                    }
                }
            } else {
                LaunchScreen()
                    .environmentObject(dataStorage)
                    .onAppear {
                        MusicPlayer.shared.startBackgroundMusic()
                    }
            }
        }
    }
}
