//
//  PlantDataSet.swift
//  PlantWithJ
//
//  Created by 장지수 on 2023/03/17.
//
import UIKit
import Foundation

struct TestData {
    static var dummyPlants: [PlantInformationModel] = [
        PlantInformationModel(
            imageData: UIImage(named: "TestPlantImage")?
                .jpegData(compressionQuality: 0.2) ?? Data(),
            name: "Dino",
            species: "Happy tree set",
            birthDay: Date(),
            wateringDay: [Date(), Date(), Date()]),
        
        PlantInformationModel(
            imageData: UIImage(named: "TestPlantImage")?
                .jpegData(compressionQuality: 0.2) ?? Data(),
            name: "ReGo",
            species: "SpartFilm",
            birthDay: Date(),
            wateringDay: [Date(), Date(), Date()]),
        
        PlantInformationModel(
            imageData: UIImage(named: "TestPlantImage")?
                .jpegData(compressionQuality: 0.2) ?? Data(),
            name: "MiMiNoRiki",
            species: "Unknown",
            birthDay: Date(),
            wateringDay: [Date()]),
        
        PlantInformationModel(
            imageData: UIImage(named: "TestPlantImage")?
                .jpegData(compressionQuality: 0.2) ?? Data(),
            name: "Albes",
            species: "Allowari",
            birthDay: Date(),
            wateringDay: [Date(), Date(), Date()]),
        
        PlantInformationModel(
            imageData: UIImage(named: "TestPlantImage")?
                .jpegData(compressionQuality: 0.2) ?? Data(),
            name: "Races",
            species: "Happy tree set",
            birthDay: Date(),
            wateringDay: [Date()])
    ]
    
    static var dummyDiary: [DiaryDataModel] = [
        DiaryDataModel(
            date: Date(),
            image: UIImage(named: "TestPlantImage")?
                .jpegData(compressionQuality: 0.2) ?? Data(),
            diaryText: "오늘은 식물이 3개나 자랏다 완전 굿!"),
        
        DiaryDataModel(
            date: Date(),
            image: UIImage(named: "TestPlantImage")?
                .jpegData(compressionQuality: 0.2) ?? Data(),
            diaryText: "오늘은 식물이 3개나 자랏다 완전 굿!오늘은 식물이 3개나 자랏다 완전 굿! 오늘은 식물이 3개나 자랏다 완전 굿! 오늘은 식물이 3개나 자랏다 완전 굿!"),
        
        DiaryDataModel(
            date: Date(),
            image: UIImage(named: "TestPlantImage")?
                .jpegData(compressionQuality: 0.2) ?? Data(),
            diaryText: "오늘은 식물이 3개나 자랏다 완전 굿! 오늘은 식물이 3개나 자랏다 완전 굿! 오늘은 식물이 3개나 자랏다 완전 굿!"),
        
        DiaryDataModel(
            date: Date(),
            image: UIImage(named: "TestPlantImage")?
                .jpegData(compressionQuality: 0.2) ?? Data(),
            diaryText: "오늘은 식물이 3개나 자랏다 완전 굿!"),
        
        DiaryDataModel(
            date: Date(),
            image: UIImage(named: "TestPlantImage")?
                .jpegData(compressionQuality: 0.2) ?? Data(),
            diaryText: "오늘은 식물이 3개나 자랏다 완전 굿!")
    ]
}
