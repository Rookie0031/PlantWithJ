//
//  PlantImageView.swift
//  PlantWithJ
//
//  Created by 장지수 on 2023/03/29.
//

import UIKit
import SwiftUI

struct PlantImageView: View {
    @State private var scale: CGFloat = 1.0
    let imageData: Data
    var body: some View {
        Image(uiImage: UIImage(data: imageData) ?? UIImage())
            .resizable()
             .scaledToFit()
             .scaleEffect(scale)
             .gesture(
                 MagnificationGesture()
                     .onChanged { value in
                         self.scale = value.magnitude
                     }
                     .onEnded { value in
                         self.scale = min(max(self.scale * value.magnitude, 0.5), 3.0)
                     }
             )
             .edgesIgnoringSafeArea(.all)
    }
}
