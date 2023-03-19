//
//  DiaryHScrollView.swift
//  PlantWithJ
//
//  Created by 장지수 on 2023/03/12.
//

import SwiftUI

struct DiaryHScrollView: View {
    let diarySet: [DiaryDataModel]
    var body: some View {
            
        ScrollView(.horizontal) {
            LazyHStack(spacing: 20) {
                ForEach(diarySet) { diary in
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
                    
                Text(data.date.toHourAndMinute())
                        .font(.titleText)
                        .foregroundColor(.deepGreen)
                    
                Image(uiImage: UIImage(data: data.image) ?? UIImage())
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 200, height: 200, alignment: .center)
                    
                LightGrayText(text: data.diaryText)
                }
                .padding()
                .background(Color.lightGray)
                .cornerRadius(20)
    }
}

struct w_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            DiaryHScrollView(diarySet: TestData.dummyDiary)
        }
    }
}