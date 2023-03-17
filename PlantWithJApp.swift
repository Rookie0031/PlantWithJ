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
    @StateObject private var data = PlantDataStorage()
    let launchedBefore = UserDefaults.standard.bool(forKey: "launchedBefore")
    
    var body: some Scene {
        WindowGroup {
            if launchedBefore {
                NavigationStack {
                    MyPlantView(items: TestData.dummyPlants) {
                        PlantDataStorage.saveLocalData(data: data.plantData) { result in
                            if case .failure(let error) = result {
                                fatalError(error.localizedDescription)
                            }
                        }
                    }
                }
                .onAppear {
                    PlantDataStorage.loadLocalData { result in
                        switch result {
                        case .failure(let error):
                            fatalError(error.localizedDescription)
                        case .success(let plantData):
                            data.plantData = plantData
                        }
                    }
                }
            } else {
                LaunchScreen()
            }
        }
    }
}
