//
//  DiaryView.swift
//  PlantWithJ
//
//  Created by 장지수 on 2023/03/11.
//

import SwiftUI

struct DetailPlantView: View {
    var body: some View {
        ScrollView(.vertical) {
            LazyVStack(alignment: .leading,spacing: 30) {
                PlantProfileCardView()
                
                VStack {
                    HStack {
                        Text("Diary")
                            .font(.largeTitleText)
                        
                        Spacer()
                        
                        Button {
                            print("")
                        } label: {
                            Image(systemName: "pencil.circle")
                                .resizable()
                                .frame(width: 20, height: 20, alignment: .center)
                                .foregroundColor(.deepGreen)
                        }
                    }
                    .padding(.horizontal, 30)
                    
                    DiaryHScrollView()
                        .padding(.leading, 30)
                }
            }
        }
        .padding(.top, 20)
    }
}

struct PlantProfileCardView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            
            HStack {
                Text("Profile")
                    .font(.largeTitleText)
                
                Spacer()
                
                Button {
                    print("")
                } label: {
                    Image(systemName: "pencil.circle")
                        .resizable()
                        .frame(width: 20, height: 20, alignment: .center)
                        .foregroundColor(.deepGreen)
                }
            }
            
            VStack(alignment: .leading, spacing: 10) {
                Image("PlantWihJoy")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 200, height: 200, alignment: .center)
                
                HStack(spacing: 10) {
                    BlackText(text: "Species")
                    BlackText(text: ":")
                    LightGrayText(text: "dinosuar")
                }
                
                HStack(spacing: 10) {
                    BlackText(text: "Birthday")
                    BlackText(text: ":")
                    LightGrayText(text: "21:00")
                }
                
                VStack(alignment: .leading ,spacing: 10) {
                    BlackText(text: "Water Remind")
                    LightGrayText(text: "Tue 21:00")
                    LightGrayText(text: "Tue 21:00")
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .padding()
            .background(Color.lightGray)
            .cornerRadius(20)
        }
        .padding(.horizontal, 30) // Plant Card Ends
    }
}

struct DiaryView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            DetailPlantView()
        }
    }
}
