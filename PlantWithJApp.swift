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
            if launchedBefore {
                NavigationStack {
                    MyPlantView()
                        .environmentObject(dataStorage)
                }
                .onAppear { MusicPlayer.shared.startBackgroundMusic() }
            } else {
                NavigationStack {
                    LoginView()
                        .environmentObject(dataStorage)
                        .onAppear {
                            MusicPlayer.shared.startBackgroundMusic()
                        }
                }
            }
        }
    }
}
