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
    @State private var isSignupProgress: Bool = false
    @State private var isKeyboardVisible: Bool = false
    @State private var errorMessage: String = ""

    var body: some View {
        ZStack {
            Color.mainGreen.opacity(0.8)
                .edgesIgnoringSafeArea(.all)
            
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
                        .frame(width: 300)
                    
                    SecureField("Password", text: $password)
                        .textFieldStyle(.roundedBorder)
                        .frame(width: 300)
                    
                    SecureField("Confirm Password", text: $confirmPassword)
                        .textFieldStyle(.roundedBorder)
                        .frame(width: 300)
                }
                .padding(.top, 50)
                
                Spacer()
                
                if !isSignUpSuccessful {
                    Text(errorMessage)
                        .font(.basicText)
                        .foregroundColor(.gray)
                }
                
                Button {
                    Task {
                        isSignupProgress = true
                        if password == confirmPassword {
                            await FirebaseManager.shared.createNewAccount(email: email,password: password) { signupResult in
                                switch signupResult {
                                case .success(let result):
                                    isSignUpSuccessful = result
                                case .failure(let error):
                                    errorMessage = error.localizedDescription
                                }
                                if !isSignUpSuccessful { isSignupProgress = false }
                            }
                        } else {
                            errorMessage = "Password and confirm password are inconsistent."
                        }
                    }
                } label: {
                    if !isSignupProgress {
                        Text("Sign up")
                            .frame(width: 300, height: 50, alignment: .center)
                            .font(.buttonContent.bold())
                            .foregroundColor(.white)
                            .background(Color.deepGreen)
                            .cornerRadius(30)
                    } else {
                        ProgressView("🌿 Now making your Id 🌿")
                            .frame(width: 300, height: 50, alignment: .center)
                    }
                }
            }
            .padding()
            .navigationDestination(isPresented: $isSignUpSuccessful) {
                LaunchScreen()
                    .environmentObject(storage)
                    .navigationBarBackButtonHidden(true)
            }
            .onTapGesture { UIApplication.shared.endEditing() }
            .onReceive(NotificationCenter.default.publisher(for: UIResponder.keyboardWillShowNotification)) { _ in
                withAnimation {
                    isKeyboardVisible = true
                }
            }
            .onReceive(NotificationCenter.default.publisher(for: UIResponder.keyboardWillHideNotification)) { _ in
                withAnimation {
                    isKeyboardVisible = false
                }
            }
        }
    }
}

struct SignupView_Previews: PreviewProvider {
    static var previews: some View {
        SignupView()
    }
}

