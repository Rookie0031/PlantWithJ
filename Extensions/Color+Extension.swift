//
//  Color+Extension.swift
//  PlantWithJ
//
//  Created by 장지수 on 2023/03/07.
//

import SwiftUI

extension Color {
    init(hex: String) {
        let scanner = Scanner(string: hex)
        _ = scanner.scanString("#")
        
        var rgb: UInt64 = 0
        scanner.scanHexInt64(&rgb)
        
        let r = Double((rgb >> 16) & 0xFF) / 255.0
        let g = Double((rgb >>  8) & 0xFF) / 255.0
        let b = Double((rgb >>  0) & 0xFF) / 255.0
        self.init(red: r, green: g, blue: b)
    }
}

extension Color {
    init(hex: UInt, alpha: Double = 1) {
        self.init(
            .sRGB,
            red: Double((hex >> 16) & 0xff) / 255,
            green: Double((hex >> 08) & 0xff) / 255,
            blue: Double((hex >> 00) & 0xff) / 255,
            opacity: alpha
        )
    }
}

extension Color {
    static let mainGreen : Color = Color(hex: "CDD9C1")
    static let deepGreen: Color = Color(hex: "#83A785")
    static let mainWhite :Color = Color(hex: "F5F5F5")
    static let mainOrange : Color = Color(hex: "E0C8A4")
    static let mainBlue :Color = Color(hex: "#E0C8A4")
    static let lightGray: Color = Color(hex: "#F9F9F9")
    static let textLightGray: Color = Color(hex: "#8C8A89")
}

