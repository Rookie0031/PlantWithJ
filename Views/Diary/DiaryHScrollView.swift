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
                })!.diary.sorted(by: { $1.date < $0.date })) { diary in
                    NavigationLink {
                        DetailDiaryView(diaryData: diary)
                    } label: {
                        PlantDiaryCardView(data: diary)
                    }
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
                        .frame(width: 190, height: 253, alignment: .center)
                        .cornerRadius(10)
                    
                LightGrayText(text: data.diaryTitle)
                }
                .padding()
                .background(Color.lightGray)
                .cornerRadius(10)
    }
}
