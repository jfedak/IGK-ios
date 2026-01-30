//
//  LoginView.swift
//  Zadanie5
//
//  Created by Jakub Fedak on 16/01/2026.
//

import SwiftUI

struct LoginView: View {
    @State var username: String = ""
    @State var password: String = ""
    @State var showAlert: Bool = false
    @State var alertMessage: String = ""
    
    @EnvironmentObject var authService: AuthService
    
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Username:")
            TextField("Enter username", text: $username)
                .textInputAutocapitalization(.never)
        }
        .padding(.leading)
        .padding(.bottom, 10)
        
        VStack(alignment: .leading) {
            Text("Password:")
            SecureField("Enter password", text: $password)
        }
        .padding(.leading)
        .padding(.bottom, 30)
        
        Button("Log in") {
            Task {
                let result = await authService.signInWithServer(username: username, password: password)
                if result {
                    alertMessage = "Logged in successfully"
                } else {
                    alertMessage = authService.alertMessage!
                }
                showAlert = true
            }
        }
        .padding(.bottom, 30)
        .alert(alertMessage, isPresented: $showAlert) {
            Button("OK", role: .cancel) {
                authService.alertMessage = nil
                if authService.account != nil {
                    dismiss()
                }
            }
        }
    }
}


