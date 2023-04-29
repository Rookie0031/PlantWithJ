//
//  PlantWithJApp.swift
//  PlantWithJ
//
//  Created by 장지수 on 2023/03/07.
//
import SwiftUI
import Firebase
import FirebaseCore

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
            NavigationStack {
                if Auth.auth().currentUser != nil {
                    MyPlantView()
                        .environmentObject(dataStorage)
                        .onAppear { dataStorage.isLoggedIn = true }
                } else {
                    LoginView()
                        .environmentObject(dataStorage)
                }
            }
            .onAppear {
                MusicPlayer.shared.startBackgroundMusic()
                
                if !UserDefaults().bool(forKey: "launchedBefore") {
                    UserDefaults.standard.set(true, forKey: "launchedBefore")
                } else {
                    MusicPlayer.shared.startBackgroundMusic()
                }
            }
        }
    }
}
