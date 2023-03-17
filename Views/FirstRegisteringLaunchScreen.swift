//
//  FirstRegisteringLaunchScreen.swift
//  PlantWithJ
//
//  Created by 장지수 on 2023/03/16.
//

import SwiftUI

struct FirstRegisteringLaunchScreen: View {
    @StateObject private var data = PlantDataStorage()
    var body: some View {
        VStack {
            Spacer()
            
            Text("🍀 Welcome 🍀")
                .font(.largeTitleText)
                .foregroundColor(.deepGreen)
            
            Spacer()
            
            NavigationLink {
                MyPlantView(items: TestData.dummyPlants) {
                    PlantDataStorage.saveLocalData(data: data.plantData) { result in
                        if case .failure(let error) = result {
                            fatalError(error.localizedDescription)
                        }
                    }
                }
                    .navigationBarBackButtonHidden()
                    .navigationBarTitleDisplayMode(.large)
            } label: {
                BottomButtonUI(title: "Start")
            }
        }
    }
}

struct FirstRegisteringLaunchScreen_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            FirstRegisteringLaunchScreen()
        }
    }
}
