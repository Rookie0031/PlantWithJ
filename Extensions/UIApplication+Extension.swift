//
//  UIApplication+Extension.swift
//  PlantWithJ
//
//  Created by 장지수 on 2023/03/25.
//

import UIKit

extension UIApplication {
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
