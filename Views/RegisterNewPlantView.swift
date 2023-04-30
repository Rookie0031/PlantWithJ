//
//  NewPlantRegisterView.swift
//  PlantWithJ
//
//  Created by 장지수 on 2023/03/17.
//

import SwiftUI
import PhotosUI

struct RegisterNewPlantView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var storage: PlantDataStorage
    @ObservedObject var viewModel: DateSelectViewModel
    @State private var selectedImageData: Data? = nil

    @State private var name: String = ""
    @State private var species: String = ""
    @State private var birthday: Date = Date()
    @State private var isKeyboardVisible: Bool = false
    @State private var isRegisterProgress: Bool = false
    
    let notificationCenter = UNUserNotificationCenter.current()
    
    var body: some View {
        
        VStack(spacing: 25) {
            CameraView(imageData: $selectedImageData, originalImageData: nil)
                .padding()
            
            PlantInfoSetHStackView(text: $name, type: .textInfo, guideText: "Name", placeholer: "Name of plant")
            
            PlantInfoSetHStackView(text: $species, type: .textInfo, guideText: "Species", placeholer: "Species of plant")
            
            PlantBirthDaySetHstackView(selectedDate: $birthday, guideText: "Birthday")
            
            PlantWateringRemindSetView(viewModel: viewModel, type: .reminder, guideText: "Water Remind")
            
            Spacer()
            
            Button {
                saveNewPlantData()
                setNotification()
            } label: {
                if !isRegisterProgress {
                    // Check Required Data
                    if name.isEmpty || species.isEmpty || selectedImageData == nil {
                        BottomButtonInActive(title: "Save")
                    } else {
                        BottomButtonUI(title: "Save")
                    }
                } else {
                    ProgressView("🌿 Now registering your plant 🌿")
                        .frame(width: 300, height: 50, alignment: .center)
                }
            }
        }
        .onReceive(NotificationCenter.default.publisher(for: UIResponder.keyboardWillShowNotification)) { _ in
            withAnimation {
                isKeyboardVisible = true
            }
        }
        .onReceive(NotificationCenter.default.publisher(for: UIResponder.keyboardWillHideNotification)) { _ in
            withAnimation {
                isKeyboardVisible = false
            }
        }
        .onTapGesture { UIApplication.shared.endEditing() }
        .navigationTitle("New Plant")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarHidden(isKeyboardVisible)
    }
    
    private func saveNewPlantData() {
        let newPlantData: PlantInformationModel = PlantInformationModel(
            imageData: selectedImageData ?? Data(),
            name: name,
            species: species,
            birthDay: birthday,
            wateringDay: viewModel.selectedRemindTimes
                .map({ WateringDay(dayText: $0.day, dateInfo: $0.time) }),
            diary: [])
        
        Task {
            isRegisterProgress = true
            await FirebaseManager.shared.updatePlantProfile(with: newPlantData)
            storage.plantData = await FirebaseManager.shared.loadData()
            presentationMode.wrappedValue.dismiss()
            isRegisterProgress = false
        }
        
        if !storage.plantData.contains(where: { $0.id == newPlantData.id }) { storage.plantData.append(newPlantData) }
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
                            let request = UNNotificationRequest(identifier: name,
                                                                content: content, trigger: trigger)
                            self.notificationCenter.add(request) { error in
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
