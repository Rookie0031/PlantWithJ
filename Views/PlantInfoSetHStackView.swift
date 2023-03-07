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
    
    @State var text: String = ""
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
            } else {
                NavigationLink {
                    Text("")
                } label: {
                    Text("Click Here")
                }

            }
        }
        .padding(.horizontal, 40)
    }
}

struct PlantInfoSetHStackView_Previews: PreviewProvider {
    static var previews: some View {
        PlantInfoSetHStackView(type: .textInfo, guideText: "dasdas", placeholer: "dasdasdadasdads")
    }
}
