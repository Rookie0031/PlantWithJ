//
//  ContentView.swift
//  PlantWithJ
//
//  Created by 장지수 on 2023/03/07.
//

import SwiftUI

struct LaunchScreen: View {
    var body: some View {
        NavigationStack {
            VStack {
                Image("PlantWihJoy")
                    .resizable()
                    .frame(width: 250, height: 250, alignment:.center)
                
                NavigationLink(destination: RegisterNewPlantView()) {
                    BottomButton(title: "Start with my plant")
                }
                
            }
            .padding()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        LaunchScreen()
    }
}
