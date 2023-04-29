//
//  RegisterNewPlantView.swift
//  PlantWithJ
//
//  Created by 장지수 on 2023/03/07.
//
import UIKit
import SwiftUI
import PhotosUI

struct FirstRegisterPlantView: View {
    @EnvironmentObject var storage: PlantDataStorage
    @ObservedObject var viewModel: DateSelectViewModel
    @State private var navigateToNext: Bool = false
    @State private var selectedItem: PhotosPickerItem? = nil
    @State private var selectedImageData: Data? = nil
    @State private var name: String = ""
    @State private var species: String = ""
    @State private var birthday: Date = Date()
    @State private var isKeyboardVisible: Bool = false
    @State private var newPlantData: PlantInformationModel = PlantInformationModel(
        imageData: Data(),
        name: "",
        species: "",
        birthDay: Date(),
        wateringDay: [],
        diary: [])
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
                            .scaledToFill()
                            .frame(width: 200, height: 200)
                            .clipShape(Circle())
                    } else {
                        Image("PicturePlaceholder")
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
            
            PlantInfoSetHStackView(text: $name, type: .textInfo, guideText: "Name", placeholer: "Name of plant")
            
            PlantInfoSetHStackView(text: $species, type: .textInfo, guideText: "Species", placeholer: "Species of plant")
            
            PlantBirthDaySetHstackView(selectedDate: $birthday, guideText: "Birthday")
            
            PlantWateringRemindSetView(viewModel: viewModel, type: .reminder, guideText: "Water Remind")
            
            Spacer()
            
            Button {
                saveFirstPlantData()
                setNotification()
                navigateToNext = true
            } label: {
                if name.isEmpty || species.isEmpty || selectedImageData == nil {
                    BottomButtonInActive(title: "Next")
                } else {
                    BottomButtonUI(title: "Next")
                }
            }
        }
        .navigationDestination(isPresented: $navigateToNext, destination: {
            FirstLaunchWelcomeView()
                .environmentObject(storage)
                .navigationBarBackButtonHidden()
        })
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
        .onDisappear {
            saveFirstPlantData()
            setNotification()
            saveData(with: storage.plantData)
        }
    }
    
    //MARK: OnDisappear가 두번 실행되서 데이터 저장시 분기처리가 필요
    private func saveFirstPlantData() {
        newPlantData.imageData = selectedImageData ?? Data()
        newPlantData.name = name
        newPlantData.species = species
        newPlantData.birthDay = birthday
        newPlantData.wateringDay = viewModel.selectedRemindTimes.map({ WateringDay(dayText: $0.day, dateInfo: $0.time) })
        print(newPlantData.wateringDay)
        
        Task { await FirebaseManager.shared.updatePlantProfile(with: newPlantData) }
        
        if !storage.plantData.contains(where: { $0.id == newPlantData.id }) { storage.plantData.append(newPlantData)
        } else {
            let plantIndex = storage.plantData.firstIndex { $0.id == newPlantData.id }!
            storage.plantData[plantIndex].wateringDay = newPlantData.wateringDay
        }
    }
    
    private func setNotification() {
        notificationCenter.getNotificationSettings { settings in
            DispatchQueue.main.async {
                let title = "🍀💧Watering Remind💧🍀"
                let message = "Time to water your 🪴\(newPlantData.name)🪴"
                
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
                        }
                    }
                }
            }
        }
    }
}
