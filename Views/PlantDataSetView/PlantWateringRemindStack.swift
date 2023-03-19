//
//  PlantWateringRemindHstack.swift
//  PlantWithJ
//
//  Created by 장지수 on 2023/03/09.
//
import SwiftUI

struct PlantWateringRemindStack: View {
    
    @ObservedObject var viewModel: DateSelectViewModel
    @State var text: String = ""
    let type: InformationType
    let guideText: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            HStack {
                Text(guideText)
                    .font(Font.basicText)
                Spacer()
                
                NavigationLink {
                    DateSelectView(viewModel: viewModel)
                } label: {
                    Text("Set")
                }
            }
            .padding(.horizontal, 40)
            
            ForEach(viewModel.selectedRemindTimes, id: \.id) { data in
                HStack {
                    Image(systemName: "circle.fill")
                        .resizable()
                        .frame(width: 10, height: 10, alignment: .center)
                        .foregroundColor(.mainGreen)
                    Text(data.day)
                        .font(.basicText)
                    Text(data.time.formatted(date: .omitted, time: .shortened))
                        .font(.basicText)
                }
                .padding(.horizontal, 40)
            }
        }
    }
}

