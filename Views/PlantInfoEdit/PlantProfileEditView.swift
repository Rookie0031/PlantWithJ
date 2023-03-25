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
                            .scaledToFill()
                            .frame(width: 200, height: 200)
                            .clipShape(Circle())
                    } else {
                        Image(uiImage: UIImage(data: data.imageData) ?? UIImage())
                            .resizable()
                            .scaledToFill()
                            .frame(width: 200, height: 200)
                            .clipShape(Circle())
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
                setNotification()
                saveData(with: storage.plantData)
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
            storage.plantData[originalPlantDataIndex].wateringDay = self.viewModel.selectedRemindTimes
                .map({ WateringDay(dayText: $0.day, dateInfo: $0.time)
            })
        }
    }
    
    private func setNotification() {
        notificationCenter.getNotificationSettings { settings in
            DispatchQueue.main.async {
                let title = "🍀💧Watering Remind💧🍀"
                let message = "Time to water your plants"
                
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
