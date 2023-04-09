//
//  Notification.swift
//  PlantWithJ
//
//  Created by 장지수 on 2023/03/24.
//

import SwiftUI

let notificationCenter = UNUserNotificationCenter.current()

func requestNotifcationAuthorization() {
    notificationCenter.requestAuthorization(options: [.alert, .badge, .sound]) { (permissionGranted, error) in
        if let error { print(error) }
        if !permissionGranted { print("Permission Denied") }
    }
}
