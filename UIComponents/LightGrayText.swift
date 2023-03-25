//
//  LightGrayText.swift
//  PlantWithJ
//
//  Created by 장지수 on 2023/03/12.
//
import UIKit
import SwiftUI

struct LightGrayText: View {
    let text: String
    var body: some View {
        Text(text)
            .frame(width: 150)
            .font(.subtitleText)
            .foregroundColor(.textLightGray)
            .lineLimit(2)
            .truncationMode(.tail)
    }
}
