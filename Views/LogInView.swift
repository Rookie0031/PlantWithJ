//
//  LogInView.swift
//  PlantWithJ
//
//  Created by 장지수 on 2023/04/09.
//
import Firebase
import SwiftUI

struct SignUpView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var storage: PlantDataStorage
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var confirmedPassword: String = ""
    @State private var isSignUpSuccessful: Bool = false
    
    var body: some View {
        VStack(spacing: 20) {
            
            Spacer()
            
            Text("Try Sign Up!")
                .font(.largeTitle)
                .bold()
            
            VStack {
                Text("You can share your data")
                    .font(.headline)
                
                Text("on your iPad")
                    .font(.headline)
            }
            
            
            Image("PlantWihJoy")
                .resizable()
                .frame(width: 200, height: 200, alignment:.center)
            
            
            TextField("Email", text: $email)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            
            SecureField("Password", text: $password)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            
            SecureField("Confirm Password", text: $confirmedPassword)
                 .textFieldStyle(RoundedBorderTextFieldStyle())
            
            Button(action: {
                signUpWithFirebase()
            }) {
                if disableLogin() {
                    Text("Sign Up")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .font(Font.buttonContent.bold())
                        .foregroundColor(.gray)
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(10)
                    
                } else {
                    Text("Sign Up")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .font(Font.buttonContent.bold())
                        .foregroundColor(.black)
                        .background(Color.mainGreen)
                        .cornerRadius(10)
                }
            }
            
            Spacer()
            
            Button(action: {
                presentationMode.wrappedValue.dismiss()
            }) {
                HStack {
                    Spacer()
                    Text("Skip")
                        .padding()
                        .font(Font.buttonContent.bold())
                        .foregroundColor(.gray.opacity(0.5))
                        .cornerRadius(10)
                }
            }
        }
        .padding()
        .sheet(isPresented: $isSignUpSuccessful) {
            DataTransferView(storage: storage)
        }
    }
    
    private func signInWithFirebase() {
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            if let error = error {
                print("SignIn Error: \(error)")
            } else {
                print("SignIn Success")
            }
        }
    }
    
    private func signUpWithFirebase() {
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
             if let error = error {
                 print("SignUp Error: \(error)")
             } else {
                 let user = Auth.auth().currentUser
                 let changeRequest = user?.createProfileChangeRequest()
                 changeRequest?.commitChanges { error in
                     if let error = error {
                         print("Profile Change Request Error: \(error)")
                     } else {
                         print("SignUp Success")
                         isSignUpSuccessful = true
                     }
                 }
             }
         }
    }
    
    private func disableLogin() -> Bool {
        let passwordChecked: Bool = password == confirmedPassword
        if !email.isEmpty && passwordChecked && !password.isEmpty {
            return false
        }
        return true
    }
}


struct LogInView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpView()
    }
}
