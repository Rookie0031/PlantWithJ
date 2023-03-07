//
//  ContentView.swift
//  PlantWithJ
//
//  Created by 장지수 on 2023/03/07.
//

import SwiftUI

struct LaunchScreen: View {
    var body: some View {
        NavigationView {
            VStack {
                
                Spacer()
                
                Image("PlantWihJoy")
                    .resizable()
                    .frame(width: 250, height: 250, alignment:.center)
                
                Spacer()
                
                NavigationLink(destination:
                                RegisterNewPlantView().navigationBarBackButtonHidden()) {
                    Text("Start with my own plant")
                        .frame(width: 300, height: 60, alignment: .center)
                        .font(Font.buttonContent.bold())
                        .foregroundColor(.black)
                        .background(Color.mainGreen)
                        .cornerRadius(30)
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

