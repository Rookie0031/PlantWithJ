//
//  User.swift
//  PlantWithJ
//
//  Created by 장지수 on 2023/04/23.
//

import FirebaseFirestoreSwift
import Foundation

struct User: Codable, Identifiable {
    @DocumentID var id: String?
}


