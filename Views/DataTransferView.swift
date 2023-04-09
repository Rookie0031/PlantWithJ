//
//  DataTransferView.swift
//  PlantWithJ
//
//  Created by 장지수 on 2023/04/09.
//

import SwiftUI

struct DataTransferView: View {
    @ObservedObject var storage: PlantDataStorage
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
                storage.uploadSinglePlantData(storage.plantData.first!) { error in
                    if let error {
                        print("There's an error in data transfer process: \(error)")
                    }
                }
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
}

struct DataTransferView_Previews: PreviewProvider {
    static var previews: some View {
        DataTransferView(storage: PlantDataStorage())
    }
}
