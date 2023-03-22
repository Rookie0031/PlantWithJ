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
    @Binding var isEdited: Bool
    let remindDay: [Date]
    let guideText: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            HStack {
                Text(guideText)
                    .font(Font.basicText)
                Spacer()
                
                NavigationLink {
                    WateringDaySelectView(viewModel: viewModel, isEdited: $isEdited)
                } label: {
                    Text("Edit")
                }
            }
            .padding(.horizontal, 40)
            
            // 편집되었고, 주입된 리마인더 정보와 바뀐 정보가 다를 경우
            if isEdited && remindDay != viewModel.selectedRemindTimes.map({ $0.time}) {
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
            } else {
                ForEach(remindDay, id: \.self) { data in
                    HStack {
                        Image(systemName: "circle.fill")
                            .resizable()
                            .frame(width: 10, height: 10, alignment: .center)
                            .foregroundColor(.mainGreen)
                        Text(data.weekdayText())
                            .font(.basicText)
                        Text(data.formatted(date: .omitted, time: .shortened))
                            .font(.basicText)
                    }
                    .padding(.horizontal, 40)
                }
            }
        }
    }
}

