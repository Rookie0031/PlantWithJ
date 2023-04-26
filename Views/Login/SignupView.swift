//
//  SignupView.swift
//  PlantWithJ
//
//  Created by 장지수 on 2023/04/23.
//

import SwiftUI

struct SignupView: View {
    @StateObject var storage = PlantDataStorage()
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var confirmPassword: String = ""
    @State private var isSignUpSuccessful: Bool = false
    @State private var isProgressOn: Bool = false

    var body: some View {
        VStack(spacing: 15) {
            
            Spacer()
            
            Text("Sign up!")
                .font(.largeTitle)
                .bold()
            
            Text("🌱 Manage your plant 🌱")
            
            Text("In both iPad & iPhone ")
            
            VStack(spacing: 20) {
                TextField("Email", text: $email)
                    .textFieldStyle(.roundedBorder)
                
                SecureField("Password", text: $password)
                    .textFieldStyle(.roundedBorder)
                
                SecureField("Confirm Password", text: $confirmPassword)
                    .textFieldStyle(.roundedBorder)
            }
            .padding(.top, 50)
            
            Spacer()
            
            Button {
                Task {
                    await FirebaseManager.shared.createNewAccount(email: email,password: password) {
                        isSignUpSuccessful = true
                    }
                }
            } label: {
                Text("Sign up")
                    .frame(width: 300, height: 50, alignment: .center)
                    .font(.buttonContent.bold())
                    .foregroundColor(.white)
                    .background(Color.deepGreen)
                    .cornerRadius(30)
            }
            .padding(.bottom, 50)
        }
        .padding()
        .frame(width: screenWidth, height: screenHeight, alignment: .center)
        .background(Color.mainGreen.opacity(0.8))
        .navigationDestination(isPresented: $isSignUpSuccessful) {
            LaunchScreen()
                .environmentObject(storage)
                .navigationBarBackButtonHidden(true)
        }
    }
}

struct SignupView_Previews: PreviewProvider {
    static var previews: some View {
        SignupView()
    }
}

