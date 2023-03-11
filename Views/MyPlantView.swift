//
//  DiaryView.swift
//  PlantWithJ
//
//  Created by 장지수 on 2023/03/11.
//

import SwiftUI

struct MyPlantView: View {
    let items = [
        Item(image: "PlantWihJoy", title: "Dasdasdasddasd", subtitle: "djlasdjasldjasldj"),
        Item(image: "PlantWihJoy", title: "Title 2", subtitle: "Subtitle 2"),
        Item(image: "PlantWihJoy", title: "Title 3", subtitle: "Subtitle 3"),
        Item(image: "PlantWihJoy", title: "Title 4", subtitle: "Subtitle 4"),
        Item(image: "PlantWihJoy", title: "Title 5", subtitle: "Subtitle 5"),
        Item(image: "PlantWihJoy", title: "Title 6", subtitle: "Subtitle 6"),
        Item(image: "PlantWihJoy", title: "Title 7", subtitle: "Subtitle 7")
    ]
    
    let columns: [GridItem] = [
        GridItem(.adaptive(minimum: 150)),
        GridItem(.adaptive(minimum: 150))
    ]
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 10) {
                ForEach(items, id: \.self) { item in
                    NavigationLink {
                        Text("Diary")
                            .navigationTitle(item.title)
                    } label: {
                        VStack(alignment: .center, spacing: 8) {
                            Image(item.image)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(height: 120)
                                .clipped()
                            
                            VStack(alignment: .leading) {
                                Text(item.title)
                                    .font(.headline)
                                    .foregroundColor(.black)
                                    .fontWeight(.bold)
                                
                                Text(item.subtitle)
                                    .font(.subheadline)
                                    .foregroundColor(.mainGreen)
                            }
                        }
                        .padding()
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .background(Color.lightGray)
                        .cornerRadius(15)
                    }
                }
            }
            .padding()
        }
        .navigationTitle("Growing Plants")
    }
}

struct Item: Hashable {
    let image: String
    let title: String
    let subtitle: String
}


struct MyPlantView_Preview: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            MyPlantView()
        }
    }
}
