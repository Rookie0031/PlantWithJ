//
//  DiaryWritingView.swift
//  PlantWithJ
//
//  Created by 장지수 on 2023/03/14.
//
import PhotosUI
import SwiftUI

struct DiaryWritingView: View {
    @ObservedObject var storage: PlantDataStorage
    @Environment(\.presentationMode) var presentationMode
    @State private var selectedDate = Date()
    @State private var selectedItem: PhotosPickerItem? = nil
    @State private var selectedImageData: Data? = nil
    @State private var diaryTitle: String = ""
    @State private var text: String = ""
    @State private var isKeyboardVisible = false
    
    let id: String
    
    var body: some View {
        VStack(spacing: 40) {
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
            
            VStack(spacing: -10) {
                
                HStack {
                    Text("Date")
                        .padding(.horizontal, 30)
                    
                    DatePicker("Select a date", selection: $selectedDate, in: ...Date(), displayedComponents: [.date])
                        .datePickerStyle(.compact)
                        .labelsHidden()
                    
                    Spacer()
                }
                
                HStack {
                    Spacer()
                    
                    Image("PlantPots")
                        .resizable()
                        .frame(width: 75, height: 35, alignment: .center)
                }
                .padding(.trailing, 10)
                
                VStack(spacing: -20) {
                    ZStack(alignment: .topLeading) {
                        TextEditor(text: $diaryTitle)
                            .scrollContentBackground(.hidden)
                            .foregroundColor(.deepGreen)
                            .font(.basicText)
                            .background(Color.lightGray)
                        
                        if diaryTitle.isEmpty {
                            Text("Diary Title")
                                .font(.basicText)
                                .foregroundColor(.mainGreen)
                                .padding(.horizontal, 8)
                                .padding(.vertical, 12)
                        }
                    }
                    .frame(height: 50)
                    .padding(5)
                    .background(Color.lightGray)
                    .cornerRadius(15)
                    .padding()
                    
                    ZStack(alignment: .topLeading) {
                        TextEditor(text: $text)
                            .scrollContentBackground(.hidden)
                            .foregroundColor(.deepGreen)
                            .font(.basicText)
                            .background(Color.lightGray)
                        
                        if text.isEmpty {
                            Text("Record growth of your plant")
                                .font(.basicText)
                                .foregroundColor(.mainGreen)
                                .padding(.horizontal, 8)
                                .padding(.vertical, 12)
                        }
                    }
                    .frame(height: 200)
                    .padding(5)
                    .background(Color.lightGray)
                    .cornerRadius(15)
                .padding()
                }
            }
            
            if text.isEmpty || selectedImageData == nil {
                BottomButtonInActive(title: "Save")
                    .padding(.bottom, 10)
            } else {
                BottomButton(title: "Save") {
                    saveNewPlantData()
                    saveData(with: storage.plantData)
                    presentationMode.wrappedValue.dismiss()
                }
                .padding(.bottom, 10)
            }
        }
        .onTapGesture { UIApplication.shared.endEditing() }
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
        .navigationTitle("New Diary")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarHidden(isKeyboardVisible)
    }
    
    private func saveNewPlantData() {
        let newPlantData: DiaryDataModel = DiaryDataModel(
            date: selectedDate, image: selectedImageData ?? Data(), diaryText: text, diaryTitle: diaryTitle)
        if let plantDataIndex = storage.plantData.firstIndex(where: { $0.id == self.id }) {
            storage.plantData[plantDataIndex].diary.append(newPlantData)
        }
    }
}

struct DetailDiaryView_Previewsds: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            DiaryWritingView(storage: PlantDataStorage(), id: "")
                .navigationTitle("New Diary")
                .navigationBarTitleDisplayMode(.inline)
        }
    }
}
