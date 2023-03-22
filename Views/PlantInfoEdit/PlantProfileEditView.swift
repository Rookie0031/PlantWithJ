//
//  PlantProfileEditView.swift
//  PlantWithJ
//
//  Created by 장지수 on 2023/03/17.
//

import SwiftUI

import SwiftUI
import PhotosUI

struct PlantProfileEditView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var storage: PlantDataStorage
    @StateObject var viewModel: DateSelectViewModel = DateSelectViewModel()
    
    @State private var isReminderEdited: Bool = false
    @State private var selectedItem: PhotosPickerItem? = nil
    @State private var selectedImageData: Data? = nil
    @State private var name: String = ""
    @State private var species: String = ""
    @State private var birthday: Date = Date()
    
    let data: PlantInformationModel
    
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
                        Image(uiImage: UIImage(data: data.imageData) ?? UIImage())
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
            
            
            PlantInfoSetHStackView(text: $name, type: .textInfo, guideText: "Name", placeholer: data.name)
            
            PlantInfoSetHStackView(text: $species, type: .textInfo, guideText: "Species", placeholer: data.species)
            
            PlantBirthDayEditView(selectedDate: data.birthDay, guideText: "Birthday")
            
            PlantReminderEditView(viewModel: viewModel, isEdited: $isReminderEdited, remindDay: data.wateringDay, guideText: "Water Remind")
            
            Spacer()
            
            BottomButton(title: "Save") {
                saveEditedInformation()
                self.presentationMode.wrappedValue.dismiss()
            }
            
        }
        .navigationTitle("Edit profile")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    private func saveEditedInformation() {
        let originalPlantDataIndex = storage.plantData.firstIndex { $0.id == data.id }!
        
        if !self.name.isEmpty {
            storage.plantData[originalPlantDataIndex].name = self.name
        }
        
        if !self.species.isEmpty {
            storage.plantData[originalPlantDataIndex].species = self.species
        }
        
        if storage.plantData[originalPlantDataIndex].birthDay != data.birthDay {
            storage.plantData[originalPlantDataIndex].birthDay = self.birthday
        }
        
        if self.selectedImageData != nil {
            storage.plantData[originalPlantDataIndex].imageData = self.selectedImageData ?? Data()
        }
        
        if self.isReminderEdited {
            storage.plantData[originalPlantDataIndex].wateringDay = self.viewModel.selectedRemindTimes.compactMap({ $0.time.remindDateForm(weekday: $0.day.toWeekDayComponent(), hourAndMinute: $0.time.hourAndminute()) })
        }
    }
}
