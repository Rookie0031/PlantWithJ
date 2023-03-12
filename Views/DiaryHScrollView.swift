//
//  DiaryHScrollView.swift
//  PlantWithJ
//
//  Created by 장지수 on 2023/03/12.
//

import SwiftUI

struct DiaryHScrollView: View {
    var body: some View {
            
        ScrollView(.horizontal) {
            LazyHStack(spacing: 20) {
                PlantDiaryCardView()
                PlantDiaryCardView()
                PlantDiaryCardView()
            }
        }
    }
}

struct PlantDiaryCardView: View {
    var body: some View {
            VStack(alignment: .center, spacing: 10) {
                    
                    Text("07 May 2022")
                        .font(.titleText)
                        .foregroundColor(.deepGreen)
                    
                    Image("PlantWihJoy")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 200, height: 200, alignment: .center)
                    
                    LightGrayText(text: "dinosuardasdasdasd")
                }
                .padding()
                .background(Color.lightGray)
            .cornerRadius(20)
    }
}

struct w_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            DiaryHScrollView()
        }
    }
}
