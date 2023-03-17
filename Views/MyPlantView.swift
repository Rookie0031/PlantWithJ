//
//  DiaryView.swift
//  PlantWithJ
//
//  Created by 장지수 on 2023/03/11.
//
import UIKit
import SwiftUI

struct MyPlantView: View {
    let items = TestData.dummyPlants
    
    let columns: [GridItem] = [
        GridItem(.adaptive(minimum: 150)),
        GridItem(.adaptive(minimum: 150))
    ]
    
    init() {
        UINavigationBar.appearance().largeTitleTextAttributes = [.font : UIFont(name: "Georgia-Bold", size: 26)!]
    }
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 10) {
                ForEach(items, id: \.id) { item in
                    NavigationLink {
                        DetailPlantView(plantData: item)
                            .navigationTitle("Plant Profile")
                            .navigationBarTitleDisplayMode(.inline)
                    } label: {
                        VStack(alignment: .center, spacing: 8) {
                            Image(uiImage: UIImage(data: item.imageData) ?? UIImage())
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .cornerRadius(10)
                            
                            VStack(alignment: .leading) {
                                Text(item.name)
                                    .font(.headline)
                                    .foregroundColor(.black)
                                    .fontWeight(.bold)
                                
                                Text(item.species)
                                    .font(.subheadline)
                                    .foregroundColor(.deepGreen)
                            }
                        }
                        .padding()
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .background(Color.lightGray)
                        .cornerRadius(10)
                    }
                }
            }
            .padding()
        }
        .navigationTitle("Growing Plants")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                NavigationLink {
                    Text("Edit")
                } label: {
                    Image(systemName: "plus.circle")
                        .resizable()
                        .frame(width: 20, height: 20, alignment: .center)
                        .foregroundColor(.deepGreen)
                }
            }
        }
    }
}

struct MyPlantView_Preview: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            MyPlantView()
        }
    }
}
