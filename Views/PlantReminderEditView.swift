//
//  PlantReminderEditView.swift
//  PlantWithJ
//
//  Created by 장지수 on 2023/03/17.
//

import SwiftUI

struct PlantReminderEditView: View {
    
    @ObservedObject var viewModel: DateSelectViewModel
    @State var text: String = ""
    let remindDay: [Date]
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
                    Text("Edit")
                }
            }
            .padding(.horizontal, 40)
            
            ForEach(remindDay, id: \.self) { data in
                HStack {
                    Image(systemName: "circle.fill")
                        .resizable()
                        .frame(width: 10, height: 10, alignment: .center)
                        .foregroundColor(.mainGreen)
                    Text(data.toDay())
                        .font(.basicText)
                    Text(data.formatted(date: .omitted, time: .shortened))
                        .font(.basicText)
                }
                .padding(.horizontal, 40)
            }
        }
    }
}

