//
//  RegisterNewPlantView.swift
//  PlantWithJ
//
//  Created by 장지수 on 2023/03/07.
//

import SwiftUI
import PhotosUI

struct FirstRegisterPlantView: View {
    @EnvironmentObject var storage: PlantDataStorage
    @ObservedObject var viewModel: DateSelectViewModel
    @State private var selectedItem: PhotosPickerItem? = nil
    @State private var selectedImageData: Data? = nil
    @State private var name: String = ""
    @State private var species: String = ""
    @State private var birthday: Date = Date()
    let notificationCenter = UNUserNotificationCenter.current()
    
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
            
            NavigationLink {
                FirstLaunchWelcomeView()
                    .navigationBarBackButtonHidden()
            } label: {
                if name.isEmpty || species.isEmpty || selectedImageData == nil {
                    BottomButtonInActive(title: "Next")
                } else {
                    BottomButtonUI(title: "Next")
                }
            }
            
        }
        .navigationTitle("New Plant")
        .navigationBarTitleDisplayMode(.inline)
        .onDisappear {
            saveFirstPlantData()
            setNotification()
        }
    }
    
    private func saveFirstPlantData() {
        let firstPlantData: PlantInformationModel = PlantInformationModel(
            imageData: selectedImageData ?? Data(),
            name: name,
            species: species,
            birthDay: birthday,
            wateringDay: viewModel.selectedRemindTimes.map({ WateringDay(dayText: $0.day, dateInfo: $0.time) }),
            diary: [])
        
        if !storage.plantData.contains(where: { $0.id == firstPlantData.id }) { storage.plantData.append(firstPlantData) }
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
