//
//  ContentView.swift
//  PlantWithJ
//
//  Created by 장지수 on 2023/03/07.
//

import SwiftUI

struct LaunchScreen: View {
    @StateObject var dateViewModel: DateSelectViewModel = DateSelectViewModel()
    var body: some View {
        NavigationStack {
            VStack {
                
                Spacer()
                
                Image("PlantWihJoy")
                    .resizable()
                    .frame(width: 250, height: 250, alignment:.center)
                
                VStack(alignment: .leading, spacing: 7) {
                    Text("Record your plant's growth")
                        .font(.basicText)
                    
                    Text("Get remind of your watering")
                        .font(.basicText)
                    
                    Text("Grow your plant with joy")
                        .font(.basicText).bold()
                }
                
                Spacer()
                
                NavigationLink(destination:
                                RegisterNewPlantView(viewModel: dateViewModel).navigationBarBackButtonHidden()) {
                    Text("Start with your plant")
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

