//
//  RegisterNewPlantView.swift
//  PlantWithJ
//
//  Created by 장지수 on 2023/03/07.
//

import SwiftUI
import PhotosUI

struct RegisterFirstPlantView: View {
    @ObservedObject var viewModel: DateSelectViewModel
    @State private var selectedItem: PhotosPickerItem? = nil
    @State private var selectedImageData: Data? = nil
    
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
            
            
            PlantInfoSetHStackView(type: .textInfo, guideText: "Name", placeholer: "Name of plant")
            
            PlantInfoSetHStackView(type: .textInfo, guideText: "Species", placeholer: "Species of plant")
            
            PlantBirthDaySetHstackView(guideText: "Birthday")
            
            PlantWateringRemindStack(viewModel: viewModel, type: .reminder, guideText: "Water Remind")
            
            Spacer()
            
            NavigationLink {
                FirstRegisteringLaunchScreen()
                    .navigationBarBackButtonHidden()
            } label: {
                BottomButtonUI(title: "Next")
            }

        }
        .navigationTitle("New Plant")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct ContentView_Preview_Regiter: PreviewProvider {
    static var previews: some View {
        NavigationView {
            RegisterFirstPlantView(viewModel: DateSelectViewModel())
        }
    }
}
