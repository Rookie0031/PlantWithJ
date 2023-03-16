//
//  DiaryView.swift
//  PlantWithJ
//
//  Created by 장지수 on 2023/03/11.
//

import SwiftUI

struct DetailPlantView: View {
    let plantData: PlantInformationModel
    var body: some View {
        ScrollView(.vertical) {
            LazyVStack(alignment: .leading,spacing: 30) {
                PlantProfileCardView(data: plantData)
                
                VStack {
                    HStack {
                        Text("Diary")
                            .font(.largeTitleText)
                        
                        Spacer()
                        
                        NavigationLink {
                            DiaryWritingView()
                        } label: {
                            Image(systemName: "plus.circle")
                                .resizable()
                                .frame(width: 20, height: 20, alignment: .center)
                                .foregroundColor(.deepGreen)

                        }
                    }
                    .padding(.horizontal, 30)
                    
                    DiaryHScrollView(diarySet: TestData.dummyDiary)
                        .padding(.leading, 30)
                }
            }
        }
        .padding(.top, 20)
    }
}

struct PlantProfileCardView: View {
    let data: PlantInformationModel
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            //MARK: 여기 다른 데이터로 바꾸기
            HStack {
                Text(data.name)
                    .font(.largeTitleText)
                
                Spacer()
                
                Button {
                    print("")
                } label: {
                    Image(systemName: "pencil.circle")
                        .resizable()
                        .frame(width: 20, height: 20, alignment: .center)
                        .foregroundColor(.deepGreen)
                }
            }
            
            VStack(alignment: .center, spacing: 20) {
                Image(uiImage: UIImage(data: data.imageData) ?? UIImage())
                    .resizable()
                    .cornerRadius(10)
                    .frame(width: 180, height: 180)
                    .aspectRatio(contentMode: .fit)
                
                VStack(alignment: .leading) {
                    HStack(spacing: 10) {
                        BlackText(text: "Species")
                        BlackText(text: ":")
                        LightGrayText(text: data.species)
                    }
                    
                    HStack(spacing: 10) {
                        BlackText(text: "Birthday")
                        BlackText(text: ":")
                        LightGrayText(text: "\(data.birthDay)")
                    }
                    
                    VStack(alignment: .leading ,spacing: 10) {
                        BlackText(text: "Water Remind")
                        ForEach(data.wateringDay, id: \.self) { data in
                            LightGrayText(text: data.toDay())
                        }
                    }
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .padding()
            .background(Color.lightGray)
            .cornerRadius(20)
        }
        .padding(.horizontal, 30) // Plant Card Ends
    }
}

struct DiaryView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            DetailPlantView(plantData: TestData.dummyPlants.first!)
        }
    }
}
