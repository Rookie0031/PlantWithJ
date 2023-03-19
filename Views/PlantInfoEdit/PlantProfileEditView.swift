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
    @ObservedObject var viewModel: DateSelectViewModel
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
            
            PlantReminderEditView(viewModel: viewModel, remindDay: data.wateringDay, guideText: "Water Remind")
            
            Spacer()
            
            BottomButton(title: "Save") {
                //TODO: Needs action
                self.presentationMode.wrappedValue.dismiss()
            }

        }
        .navigationTitle("Edit profile")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct PlantProfileEditView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            PlantProfileEditView(viewModel: DateSelectViewModel(), data: TestData.dummyPlants.first!)
        }
    }
}
