//
//  DateSelectView.swift
//  PlantWithJ
//
//  Created by 장지수 on 2023/03/09.
//

import SwiftUI

struct DateSelectView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var viewModel: DateSelectViewModel
    private let components: [WeekdayHstack] = [WeekdayHstack(dayText: "Monday"),
                                               WeekdayHstack(dayText: "Tuesday"),
                                               WeekdayHstack(dayText: "Wednesday"),
                                               WeekdayHstack(dayText: "Thursday"),
                                               WeekdayHstack(dayText: "Friday"),
                                               WeekdayHstack(dayText: "Saturday"),
                                               WeekdayHstack(dayText: "Sunday")]
    
    var body: some View {
        
        VStack(spacing: 40) {
            ForEach(components, id: \.id) { component in
                component
            }
            
            Spacer()
            
            BottomButton(title: "Complete") {
                components.filter({ $0.isSelected }).forEach { component in
                    let remindTime: ReminderTimeModel = ReminderTimeModel(day: component.dayText, time: component.selectedDate)
                    var remindTimeList: [ReminderTimeModel] = []
                    remindTimeList.append(remindTime)
                    viewModel.remindTimes = remindTimeList
                    print(viewModel.remindTimes)
                }
                presentationMode.wrappedValue.dismiss()
            }
        }
        .padding(.top, 50)
        .navigationTitle("Watering Time")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct WeekdayHstack: View, Identifiable {
    
    let id: String = UUID().uuidString
    let dayText: String
    @State var isSelected: Bool = false
    @State var selectedDate = Date()
    
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

struct DateSelectView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            DateSelectView(viewModel: DateSelectViewModel())
        }
    }
}
