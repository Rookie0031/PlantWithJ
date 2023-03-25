//
//  DetailDiaryView.swift
//  PlantWithJ
//
//  Created by 장지수 on 2023/03/25.
//

import PhotosUI
import SwiftUI

struct DetailDiaryView: View {
    let diaryData: DiaryDataModel
    @State private var imageData: Data = Data()
    @State private var text: String = ""
    @State private var diaryTitle: String = ""
    @State private var date: Date = Date()
    
    var body: some View {
        VStack(spacing: 40) {
            Image(uiImage: UIImage(data: imageData) ?? UIImage())
                .resizable()
                .scaledToFill()
                .frame(width: 200, height: 200)
                .clipShape(Circle())
            
            VStack(spacing: -10) {
                HStack {
                    Text("Date")
                        .padding(.horizontal, 30)
                    
                    DatePicker("Select a date", selection: $date, in: ...Date(), displayedComponents: [.date])
                        .datePickerStyle(.compact)
                        .labelsHidden()
                    
                    Spacer()
                }
                
                HStack {
                    Spacer()
                    
                    Image("PlantPots")
                        .resizable()
                        .frame(width: 75, height: 35, alignment: .center)
                }
                .padding(.trailing, 10)
                
                VStack {
                    ZStack(alignment: .topLeading) {
                        TextEditor(text: $diaryTitle)
                            .scrollContentBackground(.hidden)
                            .foregroundColor(.deepGreen)
                            .font(.basicText)
                            .background(Color.lightGray)
                    }
                    .frame(height: 50)
                    .padding(5)
                    .background(Color.lightGray)
                    .cornerRadius(15)
                    .padding()
                    
                    ZStack(alignment: .topLeading) {
                        TextEditor(text: $text)
                            .scrollContentBackground(.hidden)
                            .foregroundColor(.deepGreen)
                            .font(.basicText)
                            .background(Color.lightGray)
                    }
                    .frame(height: 200)
                    .padding(5)
                    .background(Color.lightGray)
                    .cornerRadius(15)
                .padding()
                }
            }
            Spacer()
        }
        .onAppear(perform: {
            configureData(with: diaryData)
        })
        .disabled(true)
        .navigationTitle("Diary")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    func configureData(with data: DiaryDataModel) {
        imageData = data.image
        date = data.date
        text = data.diaryText
        diaryTitle = data.diaryTitle
    }
}

struct DetailDiaryView_Previews: PreviewProvider {
    static var previews: some View {
        DetailDiaryView(diaryData: DiaryDataModel(date: Date(), image: Data(), diaryText: "dasdasd", diaryTitle: "dasdasd"))
    }
}
