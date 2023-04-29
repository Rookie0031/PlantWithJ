//
//  DateSelectView.swift
//  PlantWithJ
//
//  Created by 장지수 on 2023/03/09.
//

import SwiftUI

struct WateringDaySelectView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var viewModel: DateSelectViewModel
    @Binding var isEdited: Bool
    private let weekDays: [String] = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"]
    
    var body: some View {
        
        VStack(spacing: 40) {
            WeekdayHstack(isSelected: $viewModel.remindTimes[0].isSelected, selectedDate: $viewModel.remindTimes[0].time, dayText: "Monday")
            
            WeekdayHstack(isSelected: $viewModel.remindTimes[1].isSelected, selectedDate: $viewModel.remindTimes[1].time, dayText: "Tuesday")
            
            WeekdayHstack(isSelected: $viewModel.remindTimes[2].isSelected, selectedDate: $viewModel.remindTimes[2].time, dayText: "Wednesday")
            
            WeekdayHstack(isSelected: $viewModel.remindTimes[3].isSelected, selectedDate: $viewModel.remindTimes[3].time, dayText: "Thursday")
            
            WeekdayHstack(isSelected: $viewModel.remindTimes[4].isSelected, selectedDate: $viewModel.remindTimes[4].time, dayText: "Friday")
            
            WeekdayHstack(isSelected: $viewModel.remindTimes[5].isSelected, selectedDate: $viewModel.remindTimes[5].time, dayText: "Saturday")
            
            WeekdayHstack(isSelected: $viewModel.remindTimes[6].isSelected, selectedDate: $viewModel.remindTimes[6].time, dayText: "Sunday")
            
            Spacer()
            
            BottomButton(title: "Complete") {
                viewModel.selectedRemindTimes = viewModel.remindTimes.filter { $0.isSelected }
                isEdited = true
                presentationMode.wrappedValue.dismiss()
            }
        }
        .padding(.top, 50)
        .navigationTitle("Watering Time")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct WeekdayHstack: View {
    
    @Binding var isSelected: Bool
    @Binding var selectedDate: Date
    let dayText: String
    
    var body: some View {
        HStack(spacing: 15) {
            Button {
                isSelected.toggle()
            } label: {
                Image(systemName: isSelected ? "checkmark.circle.fill" : "circle.fill")
                    .resizable()
                    .frame(width: 25, height: 25, alignment: .center)
                    .foregroundColor(.mainGreen)
            }
            Text(dayText)
                .font(.basicText)
            Spacer()
            
            if isSelected {
                DatePicker("", selection: $selectedDate, displayedComponents: .hourAndMinute)
                    .onAppear {
                        let calendar = Calendar.current
                        let defaultTime = calendar.date(bySettingHour: 9, minute: 0, second: 0, of: Date()) ?? Date()
                        selectedDate = defaultTime
                    }
            }
        }
        .padding(.horizontal, 20)
    }
}
