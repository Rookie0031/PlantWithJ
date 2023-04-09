//
//  BlackText.swift
//  PlantWithJ
//
//  Created by 장지수 on 2023/03/12.
//

import SwiftUI

struct BlackText: View {
    let text: String
    var body: some View {
        Text(text)
            .font(.subtitleText)
            .foregroundColor(.black)
    }
}
