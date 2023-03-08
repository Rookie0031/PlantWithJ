//
//  BottomButtonUI.swift
//  PlantWithJ
//
//  Created by 장지수 on 2023/03/09.
//

import SwiftUI

struct BottomButtonUI: View {
    let title: String
    var body: some View {
        Text(title)
            .frame(width: 300, height: 50, alignment: .center)
            .font(.buttonContent.bold())
            .foregroundColor(.black)
            .background(Color.mainGreen)
            .cornerRadius(30)
    }
}
