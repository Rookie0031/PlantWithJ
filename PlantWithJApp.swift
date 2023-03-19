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
                    MyPlantView(items: dataStorage.plantData) {
                        PlantDataStorage.saveLocalData(data: dataStorage.plantData) { result in
                            if case .failure(let error) = result {
                                fatalError(error.localizedDescription)
                            }
                        }
                    }
                    .environmentObject(dataStorage)
                }
                .onAppear {
                    PlantDataStorage.loadLocalData { result in
                        switch result {
                        case .failure(let error):
                            fatalError(error.localizedDescription)
                        case .success(let plantData):
                            dataStorage.plantData = plantData
                        }
                    }
                }
            } else {
                LaunchScreen()
                    .environmentObject(dataStorage)
            }
        }
    }
}
