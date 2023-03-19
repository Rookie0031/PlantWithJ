//
//  PlantInfoSetHStackView.swift
//  PlantWithJ
//
//  Created by 장지수 on 2023/03/08.
//

import SwiftUI

enum InformationType {
    case textInfo
    case reminder
    case date
    case watering
    case fertilizer
}

struct PlantInfoSetHStackView: View {
    
    @Binding var text: String
    let type: InformationType
    let guideText: String
    let placeholer: String
    
    var body: some View {
        HStack {
            Text(guideText)
                .font(Font.basicText)
            Spacer()
            
            if type == .textInfo {
                TextField(placeholer, text: $text)
                    .frame(width: 200, height: 30, alignment: .center)
                    .padding(5)
                    .font(.basicText.italic())
                    .background(Color.lightGray)
                    .cornerRadius(10)
            }
        }
        .padding(.horizontal, 40)
    }
}

struct PlantInfoSetHStackView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            VStack {
                PlantInfoSetHStackView(text: .constant("dasd"), type: .reminder, guideText: "dasdas", placeholer: "dasdasdadasdads")
                PlantBirthDaySetHstackView(selectedDate: .constant(Date()), guideText: "dasdas")
            }
        }
    }
}
