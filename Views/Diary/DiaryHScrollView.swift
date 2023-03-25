//
//  DiaryHScrollView.swift
//  PlantWithJ
//
//  Created by 장지수 on 2023/03/12.
//

import SwiftUI

struct DiaryHScrollView: View {
    @ObservedObject var viewModel: PlantDataStorage
    let plantid: String
    
    var body: some View {
        ScrollView(.horizontal) {
            LazyHStack(spacing: 20) {
                ForEach(viewModel.plantData.first(where: { $0.id == plantid
                })!.diary) { diary in
                    PlantDiaryCardView(data: diary)
                }
            }
        }
    }
}

struct PlantDiaryCardView: View {
    let data: DiaryDataModel
    
    var body: some View {
            VStack(alignment: .center, spacing: 10) {
                    
                Text(data.date.toRegularFormat())
                        .font(.titleText)
                        .foregroundColor(.deepGreen)
                    
                Image(uiImage: UIImage(data: data.image) ?? UIImage())
                        .resizable()
                        .frame(width: 200, height: 200, alignment: .center)
                        .cornerRadius(10)
                        .aspectRatio(contentMode: .fill)
                    
                LightGrayText(text: data.diaryText)
                }
                .padding()
                .background(Color.lightGray)
                .cornerRadius(20)
    }
}
