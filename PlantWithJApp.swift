//
//  PlantWithJApp.swift
//  PlantWithJ
//
//  Created by 장지수 on 2023/03/07.
//
import Foundation
import SwiftUI

@main
struct PlantWithJApp: App {
    @StateObject private var dataStorage = PlantDataStorage()
    let launchedBefore = UserDefaults.standard.bool(forKey: "launchedBefore")
    
    var body: some Scene {
        WindowGroup {
            if launchedBefore {
                NavigationStack {
                    MyPlantView()
                        .environmentObject(dataStorage)
                }
                .onAppear {
                    PlantDataStorage.loadLocalData { result in
                        switch result {
                        case .failure(let error):
                            print("Data Load Error Occured: \(error)")
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
