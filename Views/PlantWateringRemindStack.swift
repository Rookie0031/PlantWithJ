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
        VStack {
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
            
            VStack(spacing: 10) {
                ForEach(viewModel.remindTimes, id: \.id) { data in
                    Text(data.day)
                        .font(.basicText)
                    Text(data.time.formatted(date: .complete, time: .shortened))
                        .font(.basicText)
                }
            }
        }
    }
}

