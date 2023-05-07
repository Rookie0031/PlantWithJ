//
//  LoginView.swift
//  PlantWithJ
//
//  Created by 장지수 on 2023/04/23.
//

import SwiftUI


struct LoginView: View {
    @EnvironmentObject var storage: PlantDataStorage
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var showSignup: Bool = false
    @State private var isLoginSuccessful: Bool = false
    @State private var isLoginProgress: Bool = false
    @State private var isKeyboardVisible: Bool = false
    @State private var logInErrorMessage: String = ""

    var body: some View {
        
        ZStack {
            VStack(spacing: 15) {
                
                Spacer()
                
                VStack {
                    
                    Image("LeafLogLaunchImage")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 330, height: 330, alignment: .center)
                    
                    Text("🌱 Grow with your plant 🌱")
                        .font(.titleText)
                        .foregroundColor(.deepGreen)
                        .padding(.bottom, 30)
                }
                
                TextField("Email", text: $email)
                    .textFieldStyle(CustomTextFieldStyle())
                    .background(Color.mainGreen.opacity(0.3))
                    .foregroundColor(.mainGreen)
                    .frame(width: 250)
                    .cornerRadius(20)
                
                SecureField("Password", text: $password)
                    .textFieldStyle(CustomTextFieldStyle())
                    .background(Color.mainGreen.opacity(0.3))
                    .foregroundColor(.mainGreen)
                    .frame(width: 250)
                    .cornerRadius(20)
                
                Spacer()
                
                VStack(spacing: 30) {
                    Button {
                        Task {
                            isLoginProgress = true
                            let userId = await FirebaseManager.shared.login(email: email, password: password) { loginResult in
                                switch loginResult {
                                case .success(let loginResult):
                                    isLoginSuccessful = loginResult
                                case .failure(let error):
                                    logInErrorMessage = error.localizedDescription
                                }
                                if !isLoginSuccessful { isLoginProgress = false }
                            }
                            if let userId { storage.userId = userId }
                        }
                    } label: {
                        if !isLoginProgress {
                            Text("Login")
                                .frame(width: 250, height: 50, alignment: .center)
                                .font(.buttonContent.bold())
                                .foregroundColor(.white)
                                .background(Color.deepGreen.opacity(0.7))
                                .cornerRadius(30)
                        } else {
                            ProgressView("🌿 Now Checking your id 🌿")
                                .frame(width: 250, height: 50, alignment: .center)
                        }
                    }
                    
                    if isLoginSuccessful == false {
                        Text(logInErrorMessage)
                            .font(.basicText)
                            .foregroundColor(.gray)
                    }
                    
                    Button {
                        showSignup.toggle()
                    } label: {
                        Text("Don't have an account?")
                            .foregroundColor(.mainGreen)
                    }
                }
                .padding()
            }
            .padding()
            .frame(width: screenWidth, height: screenHeight, alignment: .center)
//            .background(Color.mainGreen.opacity(0.8))
            .toolbar(.hidden)
            .navigationDestination(isPresented: $showSignup) { SignupView() }
            .navigationDestination(isPresented: $isLoginSuccessful) {
                MyPlantView()
                    .environmentObject(storage)
                    .navigationBarBackButtonHidden(true)
            }
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


struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            LoginView()
                .environmentObject(PlantDataStorage())
        }
    }
}
