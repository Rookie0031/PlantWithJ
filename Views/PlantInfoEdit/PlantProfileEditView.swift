//
//  PlantProfileEditView.swift
//  PlantWithJ
//
//  Created by 장지수 on 2023/03/17.
//

import SwiftUI
import PhotosUI

struct PlantProfileEditView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var storage: PlantDataStorage
    @StateObject var viewModel: DateSelectViewModel = DateSelectViewModel()
    
    @State private var isReminderEdited: Bool = false
    @State private var selectedImageData: Data? = nil
    @State private var editedName: String = ""
    @State private var species: String = ""
    @State private var isUpdateProgress: Bool = false
    
    let data: PlantInformationModel
    
    var body: some View {
        
        VStack(spacing: 25) {
            CameraView(imageData: $selectedImageData, originalImageData: data.imageData)
                .padding()
            
            PlantInfoSetHStackView(text: $editedName, type: .textInfo, guideText: "Name", placeholer: data.name)
            
            PlantInfoSetHStackView(text: $species, type: .textInfo, guideText: "Species", placeholer: data.species)
            
            PlantBirthDayEditView(storage: storage,selectedDate: storage.plantData.specifiedPlant(with: data.id).birthDay, guideText: "Birthday", plantId: data.id)
            
            PlantReminderEditView(viewModel: viewModel, isEdited: $isReminderEdited, remindDay: data.wateringDay, guideText: "Water Remind")
            
            Spacer()
            
            if !isUpdateProgress {
                BottomButton(title: "Save") {
                    saveEditedInformation()
                    saveEditedNotification()
                }
            } else {
                ProgressView("🌿 Now updating edited information🌿")
                    .frame(width: 300, height: 50, alignment: .center)
            }
        }
        .navigationTitle("Edit profile")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    private func saveEditedInformation() {
        let updatingPlantDataIndex = storage.plantData.firstIndex { $0.id == data.id }!
        
        if !self.editedName.isEmpty {
            storage.plantData[updatingPlantDataIndex].name = self.editedName
        }
        
        if !self.species.isEmpty {
            storage.plantData[updatingPlantDataIndex].species = self.species
        }
        
        if self.selectedImageData != nil {
            storage.plantData[updatingPlantDataIndex].imageData = self.selectedImageData ?? Data()
        }
        
        if self.isReminderEdited {
            storage.plantData[updatingPlantDataIndex].wateringDay = self.viewModel.selectedRemindTimes
                .map({ WateringDay(dayText: $0.day, dateInfo: $0.time)
            })
        }
        
        let updatingPlantData = storage.plantData[updatingPlantDataIndex]
        
        Task {
            isUpdateProgress = true
            await FirebaseManager.shared.updatePlantProfile(with: updatingPlantData)
            self.presentationMode.wrappedValue.dismiss()
            isUpdateProgress = false
        }
    }
    
    private func saveEditedNotification() {
        
        notificationCenter.removePendingNotificationRequests(withIdentifiers: [editedName])
        
        notificationCenter.getNotificationSettings { settings in
            DispatchQueue.main.async {
                let title = "🍀💧Watering Remind💧🍀"
                var plantName = ""
                if editedName.isEmpty {
                    plantName = data.name
                } else {
                    plantName = editedName
                }
                let message = "Time to water your 🪴\(plantName)🪴"
                
                if settings.authorizationStatus == .authorized {
                    let content = UNMutableNotificationContent()
                    content.title = title
                    content.body = message
                    
                    if !viewModel.selectedRemindTimes.isEmpty {
                        for dateInfo in viewModel.selectedRemindTimes {
                            var dateComponent = Calendar.autoupdatingCurrent.dateComponents(
                                [.hour, .minute], from: dateInfo.time)
                            
                            dateComponent.weekday = dateInfo.day.toWeekDayComponent()
                            
                            let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponent,
                                                                        repeats: true)
                            let request = UNNotificationRequest(identifier: UUID().uuidString,
                                                                content: content, trigger: trigger)
                            notificationCenter.add(request) { error in
                                if let error {
                                    print(error)
                                    return
                                }
                            }
                            print("request에 요청된 날짜 정보는 다음과 같습니다. \(dateComponent)") // Test
                            print("notification center에 요청된 정보는 다음과 같습니다 \(request)") // Test
                        }
                    }
                }
            }
        }
    }
}
