//
//  DataTransferView.swift
//  PlantWithJ
//
//  Created by 장지수 on 2023/04/09.
//

import SwiftUI

struct DataTransferView: View {
    @EnvironmentObject var storage: PlantDataStorage
    var body: some View {
        VStack {
            Spacer()
            
            VStack(spacing: 20) {
                Text("Data Transfer")
                    .font(.largeTitle)
                    .bold()
                
                Text("Already have registered plants?")
                
                Text("Trasnfer your data quickly, safely ")
            }
            
            Spacer()
            
            Button(action: {
                print("")
            }) {
                    Text("Next")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .font(Font.buttonContent.bold())
                        .foregroundColor(.black)
                        .background(Color.mainGreen)
                        .cornerRadius(10)
            }
        }
        .padding()
    }
    
    private func transferDeviceData() {
        
    }
}

struct DataTransferView_Previews: PreviewProvider {
    static var previews: some View {
        DataTransferView()
    }
}
