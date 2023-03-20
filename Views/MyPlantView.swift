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
    let items: [PlantInformationModel]
    let saveAction: ()->Void
    
    let columns: [GridItem] = [
        GridItem(.adaptive(minimum: 150)),
        GridItem(.adaptive(minimum: 150))
    ]
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 10) {
                ForEach(items, id: \.id) { item in
                    NavigationLink {
                        DetailPlantView(plantData: item)
                            .environmentObject(storage)
                            .navigationTitle("Plant Profile")
                            .navigationBarTitleDisplayMode(.inline)
                    } label: {
                        VStack(alignment: .center, spacing: 8) {
                            Image(uiImage: UIImage(data: item.imageData) ?? UIImage())
                                .resizable()
                                .frame(height: 200)
                                .aspectRatio(contentMode: .fit)
                                .cornerRadius(10)
                            
                            VStack(alignment: .leading) {
                                Text(item.name)
                                    .font(.headline)
                                    .foregroundColor(.black)
                                    .fontWeight(.bold)
                                
                                Text(item.species)
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
                    RegisterNewPlantView(viewModel: DateSelectViewModel())
                } label: {
                    Image(systemName: "plus.circle")
                        .resizable()
                        .frame(width: 20, height: 20, alignment: .center)
                        .foregroundColor(.deepGreen)
                }
            }
        }
        .onChange(of: scenePhase) { phase in
            if phase == .inactive { saveAction() }
        }
    }
}

struct MyPlantView_Preview: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            MyPlantView(items: TestData.dummyPlants) {
                PlantDataStorage.saveLocalData(data: TestData.dummyPlants) { result in
                    if case .failure(let error) = result {
                        fatalError(error.localizedDescription)
                    }
                }
            }
        }
    }
}
