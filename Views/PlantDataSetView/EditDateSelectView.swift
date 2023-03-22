//
//  EditEditDateSelectView.swift
//  PlantWithJ
//
//  Created by 장지수 on 2023/03/22.
//

import SwiftUI

struct EditDateSelectView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var viewModel: EditDateSelectViewModel
    private let weekDays: [String] = ["Monday", "Tuesday", "Wednesday", "Thurday", "Friday", "Saturday", "Sunday"]
    
    var body: some View {
        
        VStack(spacing: 40) {
            EditWeekdayHstack(isSelected: $viewModel.remindTimes[0].isSelected, selectedDate: $viewModel.remindTimes[0].time, dayText: "Monday")
            
            EditWeekdayHstack(isSelected: $viewModel.remindTimes[1].isSelected, selectedDate: $viewModel.remindTimes[1].time, dayText: "Tuesday")
            
            EditWeekdayHstack(isSelected: $viewModel.remindTimes[2].isSelected, selectedDate: $viewModel.remindTimes[2].time, dayText: "Wednesday")
            
            EditWeekdayHstack(isSelected: $viewModel.remindTimes[3].isSelected, selectedDate: $viewModel.remindTimes[3].time, dayText: "Thurday")
            
            EditWeekdayHstack(isSelected: $viewModel.remindTimes[4].isSelected, selectedDate: $viewModel.remindTimes[4].time, dayText: "Friday")
            
            EditWeekdayHstack(isSelected: $viewModel.remindTimes[5].isSelected, selectedDate: $viewModel.remindTimes[5].time, dayText: "Saturday")
            
            EditWeekdayHstack(isSelected: $viewModel.remindTimes[6].isSelected, selectedDate: $viewModel.remindTimes[6].time, dayText: "Sunday")
            
            Spacer()
            
            BottomButton(title: "Complete") {
                viewModel.selectedRemindTimes = viewModel.remindTimes.filter { $0.isSelected }
                presentationMode.wrappedValue.dismiss()
            }
        }
        .padding(.top, 50)
        .navigationTitle("Watering Time")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct EditWeekdayHstack: View {
    
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
                        let defaultTime = calendar.date(bySettingHour: 21, minute: 0, second: 0, of: Date()) ?? Date()
                        selectedDate = defaultTime
                    }
            }
        }
        .padding(.horizontal, 20)
    }
}

struct EditDateSelectView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            EditDateSelectView(viewModel: EditDateSelectViewModel())
        }
    }
}


