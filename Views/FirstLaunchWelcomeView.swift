//
//  FirstRegisteringLaunchScreen.swift
//  PlantWithJ
//
//  Created by 장지수 on 2023/03/16.
//

import SwiftUI

struct FirstLaunchWelcomeView: View {
    @EnvironmentObject var data: PlantDataStorage
    var body: some View {
        VStack {
            Spacer()
            
            Text("🍀 Welcome 🍀")
                .font(.largeTitleText)
                .foregroundColor(.deepGreen)
            
            Spacer()
            
            NavigationLink {
                MyPlantView(items: data.plantData) {
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
            FirstLaunchWelcomeView()
                .environmentObject(PlantDataStorage())
        }
    }
}
