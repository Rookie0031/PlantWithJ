//
//  BottomButton.swift
//  PlantWithJ
//
//  Created by 장지수 on 2023/03/07.
//

import SwiftUI

struct BottomButton: View {
    
    let title: String
    var action: (() -> Void)? = nil
    
    var body: some View {
        Button {
            if let action { action() }
        } label: {
            Text(title)
                .frame(width: 300, height: 50, alignment: .center)
                .font(Font.buttonContentFont.bold())
                .foregroundColor(.black)
                .background(Color.mainGreen)
                .cornerRadius(30)
        }
    }
}

