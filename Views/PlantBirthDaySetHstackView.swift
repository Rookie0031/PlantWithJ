//
//  PlantBirthDaySetHstack.swift
//  PlantWithJ
//
//  Created by 장지수 on 2023/03/17.
//

import SwiftUI

struct PlantBirthDaySetHstackView: View {
    @State private var selectedDate = Date()
    let guideText: String
    
    @State var text: String = ""
    var body: some View {
        HStack {
            Text(guideText)
                .font(Font.basicText)
            Spacer()
            
            DatePicker("Select a date", selection: $selectedDate, in: Date()..., displayedComponents: [.date])
                .datePickerStyle(.compact)
                .labelsHidden()
        }
        .padding(.horizontal, 40)
    }
}
