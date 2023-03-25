//
//  DiaryView.swift
//  PlantWithJ
//
//  Created by 장지수 on 2023/03/11.
//
import UIKit
import SwiftUI

struct MyPlantView: View {
    @EnvironmentObject var storage: PlantDataStorage
    @Environment(\.scenePhase) private var scenePhase
    
    let columns: [GridItem] = [
        GridItem(.adaptive(minimum: 150)),
        GridItem(.adaptive(minimum: 150))
    ]
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 10) {
                ForEach(storage.plantData, id: \.id) { plant in
                    NavigationLink {
                        DetailPlantView(plantData: plant)
                            .environmentObject(storage)
                            .navigationTitle("Plant Profile")
                            .navigationBarTitleDisplayMode(.inline)
                    } label: {
                        VStack(alignment: .center, spacing: 8) {
                            Image(uiImage: UIImage(data: plant.imageData) ?? UIImage())
                                .resizable()
                                .frame(height: 200)
                                .aspectRatio(contentMode: .fit)
                                .cornerRadius(10)
                            
                            VStack(alignment: .leading) {
                                Text(plant.name)
                                    .font(.headline)
                                    .foregroundColor(.black)
                                    .fontWeight(.bold)
                                
                                Text(plant.species)
                                    .font(.subheadline)
                                    .foregroundColor(.deepGreen)
                            }
                        }
                        .padding()
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .background(Color.lightGray)
                        .cornerRadius(10)
                    }
                }
            }
            .padding()
        }
        .onAppear(perform: {
            if !UserDefaults().bool(forKey: "launchedBefore") {
                UserDefaults.standard.set(true, forKey: "launchedBefore")
            }
        })
        .navigationTitle("Growing Plants")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                NavigationLink {
                    RegisterNewPlantView(storage: storage, viewModel: DateSelectViewModel())
                } label: {
                    Image(systemName: "plus.circle")
                        .resizable()
                        .frame(width: 20, height: 20, alignment: .center)
                        .foregroundColor(.deepGreen)
                }
            }
        }
        .onChange(of: scenePhase) { phase in
            if phase == .inactive { saveData(with: storage.plantData) }
        }
    }
}
