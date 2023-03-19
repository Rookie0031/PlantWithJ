//
//  BottomButtonInActive.swift
//  PlantWithJ
//
//  Created by 장지수 on 2023/03/19.
//

import SwiftUI

struct BottomButtonInActive: View {
    let title: String
    var body: some View {
        Text(title)
            .frame(width: 300, height: 50, alignment: .center)
            .font(.buttonContent.bold())
            .foregroundColor(.mainGreen)
            .background(Color.lightGray)
            .cornerRadius(30)
            .onTapGesture {
                print("InActive State")
            }
    }
}

struct BottomButtonInActive_Previews: PreviewProvider {
    static var previews: some View {
        BottomButtonInActive(title: "Next")
    }
}
