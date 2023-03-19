//
//  NewPlantRegisterView.swift
//  PlantWithJ
//
//  Created by 장지수 on 2023/03/17.
//

import SwiftUI
import PhotosUI

struct RegisterNewPlantView: View {
    @EnvironmentObject var storage: PlantDataStorage
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var viewModel: DateSelectViewModel
    @State private var selectedItem: PhotosPickerItem? = nil
    @State private var selectedImageData: Data? = nil
    
    @State private var name: String = ""
    @State private var species: String = ""
    @State private var birthday: Date = Date()
    
    var body: some View {
        
        VStack(spacing: 25) {
            PhotosPicker(
                selection: $selectedItem,
                matching: .images,
                photoLibrary: .shared()) {
                    if let selectedImageData,
                       let uiImage = UIImage(data: selectedImageData) {
                        Image(uiImage: uiImage)
                            .resizable()
                            .frame(width: 200, height: 200)
                            .scaledToFit()
                            .clipShape(Circle())
                    } else {
                        Image("PicturePlaceholder")
                            .resizable()
                            .frame(width: 200, height: 200, alignment: .center)
                            .cornerRadius(10)
                    }
                }
                .onChange(of: selectedItem) { newItem in
                    Task {
                        if let data = try? await newItem?.loadTransferable(type: Data.self) {
                            selectedImageData = data
                        }
                    }
            }
            .padding() //photo picker ends
            
            
            PlantInfoSetHStackView(text: $name, type: .textInfo, guideText: "Name", placeholer: "Name of plant")
            
            PlantInfoSetHStackView(text: $species, type: .textInfo, guideText: "Species", placeholer: "Species of plant")
            
            PlantBirthDaySetHstackView(selectedDate: $birthday, guideText: "Birthday")
            
            PlantWateringRemindStack(viewModel: viewModel, type: .reminder, guideText: "Water Remind")
            
            Spacer()
            
            if name.isEmpty || species.isEmpty || selectedImageData == nil {
                BottomButtonInActive(title: "Next")
            } else {
                BottomButton(title: "Next") {
                    saveNewPlantData()
                    presentationMode.wrappedValue.dismiss()
                }
            }

        }
        .navigationTitle("New Plant")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    private func saveNewPlantData() {
        let newPlantData: PlantInformationModel = PlantInformationModel(
            imageData: selectedImageData ?? Data(),
            name: name,
            species: species,
            birthDay: birthday,
            wateringDay: viewModel.selectedRemindTimes.map({ $0.time }),
            diary: [])
        
        if !storage.plantData.contains(where: { $0.id == newPlantData.id }) { storage.plantData.append(newPlantData) }
    }
}

struct RegisterNewPlantView_Preview: PreviewProvider {
    static var previews: some View {
        NavigationView {
            RegisterNewPlantView(viewModel: DateSelectViewModel())
        }
    }
}
