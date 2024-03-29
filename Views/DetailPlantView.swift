//
//  DiaryView.swift
//  PlantWithJ
//
//  Created by 장지수 on 2023/03/11.
//

import SwiftUI

struct DetailPlantView: View {
    @EnvironmentObject var viewModel: PlantDataStorage
    let plantData: PlantInformationModel
    var body: some View {
        ScrollView(.vertical) {
            LazyVStack(alignment: .leading,spacing: 30) {
                PlantProfileCardView(storage: viewModel,
                                     data: viewModel.plantData.first(where: { $0.id == plantData.id }) ?? PlantInformationModel(imageData: Data(), name: "error", species: "", birthDay: Date(), wateringDay: [], diary: []))
                
                VStack {
                    HStack {
                        Text("Diary")
                            .font(.largeTitleText)
                        
                        Spacer()
                        
                        NavigationLink {
                            DiaryWritingView(storage: viewModel, id: plantData.id)
                        } label: {
                            Image(systemName: "plus.circle")
                                .resizable()
                                .frame(width: 20, height: 20, alignment: .center)
                                .foregroundColor(.deepGreen)

                        }
                    }
                    .padding(.horizontal, 30)
                    
                    DiaryHScrollView(viewModel: viewModel, plantid: plantData.id)
                        .padding(.leading, 30)
                }
            }
        }
        .padding(.top, 20)
    }
}

struct PlantProfileCardView: View {
    @ObservedObject var storage: PlantDataStorage
    @State private var isShowingFullImage: Bool = false
    let data: PlantInformationModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text(data.name)
                    .font(.largeTitleText)
                
                Spacer()
                
                NavigationLink {
                    PlantProfileEditView(storage: storage,
                                         viewModel: DateSelectViewModel(),
                                         data: data)
                } label: {
                    Image(systemName: "pencil.circle")
                        .resizable()
                        .frame(width: 20, height: 20, alignment: .center)
                        .foregroundColor(.deepGreen)
                }
            }
            
            VStack(alignment: .center, spacing: 20) {
                Button(action: {
                    self.isShowingFullImage = true
                }) {
                    Image(uiImage: UIImage(data: data.imageData) ?? UIImage())
                        .resizable()
                        .scaledToFill()
                        .frame(width: 200, height: 200)
                        .clipShape(Circle())
                }
                
                VStack(alignment: .leading, spacing: 5) {
                    HStack(spacing: 10) {
                        BlackText(text: "Species")
                        BlackText(text: ":")
                        LightGrayText(text: data.species)
                    }
                    
                    HStack(spacing: 10) {
                        BlackText(text: "Birthday")
                        BlackText(text: ":")
                        LightGrayText(text: data.birthDay.toBirthDayStringText())
                    }
                    
                    VStack(alignment: .leading ,spacing: 10) {
                        BlackText(text: "Water Remind")
                        ForEach(storage.plantData.first(where: { $0.id == data.id })!.wateringDay, id: \.self) { data in
                            HStack {
                                Image(systemName: "circle.fill")
                                    .resizable()
                                    .frame(width: 10, height: 10, alignment: .center)
                                    .foregroundColor(.mainGreen)
                                Text(data.dayText)
                                    .font(.basicText)
                                Text(data.dateInfo.formatted(date: .omitted, time: .shortened))
                                    .font(.basicText)
                            }
                        }
                    }
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .padding()
            .background(Color.lightGray)
            .cornerRadius(20)
            .sheet(isPresented: $isShowingFullImage) {
                PlantImageView(imageData: data.imageData)
            }
        }
        .padding(.horizontal, 30) // Plant Card Ends
    }
}
