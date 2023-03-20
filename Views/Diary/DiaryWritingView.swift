//
//  DiaryWritingView.swift
//  PlantWithJ
//
//  Created by 장지수 on 2023/03/14.
//
import PhotosUI
import SwiftUI

struct DiaryWritingView: View {
    @EnvironmentObject var storage: PlantDataStorage
    @Environment(\.presentationMode) var presentationMode
    @State private var selectedDate = Date()
    @State private var selectedItem: PhotosPickerItem? = nil
    @State private var selectedImageData: Data? = nil
    @State private var text: String = ""
    
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
            
            VStack(spacing: -10) {
                
                HStack {
                    Text("Date")
                        .padding(.horizontal, 30)
                    
                    DatePicker("Select a date", selection: $selectedDate, in: Date()..., displayedComponents: [.date])
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
            
            Spacer()
            
            if text.isEmpty || selectedImageData == nil {
                BottomButtonInActive(title: "Save")
            } else {
                BottomButton(title: "Save") {
//                    saveNewPlantData()
                    presentationMode.wrappedValue.dismiss()
                }
            }
        }
        .navigationTitle("New Diary")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    private func saveNewPlantData() {
        let newPlantData: DiaryDataModel = DiaryDataModel(
            date: selectedDate, image: selectedImageData ?? Data(), diaryText: text)
        if let plantDataIndex = storage.plantData.firstIndex(where: { $0.id == self.id }) {
            storage.plantData[plantDataIndex].diary.append(newPlantData)
        }
    }
}

struct DiaryWritingView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            DiaryWritingView(id: "dasd")
        }
    }
}
