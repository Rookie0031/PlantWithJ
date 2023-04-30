//
//  SettingView.swift
//  PlantWithJ
//
//  Created by 장지수 on 2023/04/29.
//

import SwiftUI

struct SettingView: View {
    @ObservedObject var storage: PlantDataStorage
    @State private var returnToRootView: Bool = false
    @State private var showingLogoutAlert: Bool = false
    @State private var showingDeleteAccountAlert: Bool = false
    @State private var isTaskProgress: Bool = false
    @State private var taskName: String = ""
    var body: some View {
        if isTaskProgress {
            ProgressView(taskName)
        } else {
            List {
                Button(action: {
                    storage.isLoggedIn = false
                    showingLogoutAlert = true
                }) {
                    HStack {
                        Text("Logout")
                        Spacer()
                        Image(systemName: "chevron.right")
                    }
                    .foregroundColor(.gray)
                }
                .alert(isPresented: $showingLogoutAlert) {
                    Alert(
                        title: Text("Logout"),
                        message: Text("Are you sure you want to logout?"),
                        primaryButton: .default(Text("Logout")) {
                            Task {
                                taskName = "Logout progress is on"
                                isTaskProgress = true
                                await FirebaseManager.shared.signOut()
                                returnToRootView.toggle()
                                isTaskProgress = false
                                showingLogoutAlert = false
                            }
                        },
                        secondaryButton: .cancel()
                    )
                }
                
                Button(action: {
                    storage.isLoggedIn = false
                    showingDeleteAccountAlert = true
                }) {
                    HStack {
                        Text("Delete Account")
                        Spacer()
                        Image(systemName: "chevron.right")
                    }
                    .foregroundColor(.gray)
                }
                .alert(isPresented: $showingDeleteAccountAlert) {
                    Alert(
                        title: Text("Delete Account"),
                        message: Text("Are you sure you want to delete your account?"),
                        primaryButton: .destructive(Text("Delete Account")) {
                            Task {
                                taskName = "Deleting account progress is on"
                                isTaskProgress = true
                                await FirebaseManager.shared.deleteAccount()
                                showingDeleteAccountAlert = false
                                isTaskProgress = false
                                returnToRootView.toggle()
                            }
                        },
                        secondaryButton: .cancel()
                    )
                }
            }
            .navigationTitle("Setting")
            .listStyle(.insetGrouped)
            .navigationDestination(isPresented: $returnToRootView) {
                LoginView()
                    .environmentObject(storage)
            }

        }
    }
}
