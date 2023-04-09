//
//  PlantBirthdayEditView.swift
//  PlantWithJ
//
//  Created by 장지수 on 2023/03/17.
//

import SwiftUI

struct PlantBirthDayEditView: View {
    
    @ObservedObject var storage: PlantDataStorage
    @State var selectedDate: Date
    let guideText: String
    let plantId: String
    
    @State var text: String = ""
    var body: some View {
        HStack {
            Text(guideText)
                .font(Font.basicText)
            Spacer()
            
            DatePicker("Select a date", selection: $selectedDate, in: ...Date(), displayedComponents: [.date])
                .datePickerStyle(.compact)
                .labelsHidden()
                .onChange(of: selectedDate) { newValue in
                    let index = storage.plantData.indexOfPlant(with: plantId)
                    storage.plantData[index].birthDay = selectedDate
                }
        }
        .padding(.horizontal, 40)
    }
}
