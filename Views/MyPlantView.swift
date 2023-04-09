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
    @State private var isEditing: Bool = false
    @State private var showAlert: Bool = false
    @State private var isBackgroundMusicOn: Bool = true
    
    let columns: [GridItem] = [
        GridItem(.adaptive(minimum: 130)),
        GridItem(.adaptive(minimum: 130))
    ]
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 10) {
                ForEach(storage.plantData, id: \.id) { plant in
                    if !isEditing {
                        NavigationLink {
                            DetailPlantView(plantData: plant)
                                .environmentObject(storage)
                                .navigationTitle("Plant Detail")
                                .navigationBarTitleDisplayMode(.inline)
                        } label: {
                            VStack(alignment: .center, spacing: 8) {
                                Image(uiImage: UIImage(data: plant.imageData) ?? UIImage())
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 140, height: 140)
                                    .clipShape(Circle())
                                
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
                    } else {
                        ZStack(alignment: .topTrailing) {
                            VStack(alignment: .center, spacing: 8) {
                                Image(uiImage: UIImage(data: plant.imageData) ?? UIImage())
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 140, height: 140)
                                    .clipShape(Circle())
                                
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
                            
                            Button(action: {
                                showAlert = true
                            }, label: {
                                Image(systemName: "minus.circle")
                                    .foregroundColor(.red)
                            })
                        }
                        .alert(isPresented: $showAlert) {
                            Alert(
                                title: Text("Plant Delete"),
                                message: Text("Are you sure you want to delete \(plant.name)?"),
                                primaryButton: .destructive(Text("Delete")) {
                                    storage.plantData.removeAll { $0.id == plant.id }
                                    saveData(with: storage.plantData)
                                    showAlert = false
                                },
                                secondaryButton: .cancel()
                            )
                        }
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
            ToolbarItemGroup(placement: .navigationBarTrailing) {
                
                HStack(spacing: -1) {
                    Button(action: {
                        isEditing.toggle()
                    }, label: {
                        Image(systemName: "trash.circle")
                            .foregroundColor(.deepGreen)
                    })
                    
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
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: {
                    if isBackgroundMusicOn {
                        MusicPlayer.shared.stopBackgroundMusic()
                    } else {
                        MusicPlayer.shared.startBackgroundMusic()
                    }
                    isBackgroundMusicOn.toggle()
                }, label: {
                    Image(systemName: isBackgroundMusicOn ? "speaker.wave.2" : "speaker.slash")
                        .foregroundColor(.deepGreen)
                })
            }
        }
        .onChange(of: scenePhase) { phase in
            if phase == .inactive { saveData(with: storage.plantData) }
        }
    }
}
