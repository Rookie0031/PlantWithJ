//
//  PlaceholderPadding.swift
//  PlantWithJ
//
//  Created by 장지수 on 2023/05/07.
//

import SwiftUI

public struct CustomTextFieldStyle : TextFieldStyle {
    public func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
//                .font(.largeTitle) // set the inner Text Field Font
            .padding(10) // Set the inner Text Field Padding
            //Give it some style
//                .background(
//                    RoundedRectangle(cornerRadius: 5)
//                        .strokeBorder(Color.primary.opacity(0.5), lineWidth: 3))
    }
}
