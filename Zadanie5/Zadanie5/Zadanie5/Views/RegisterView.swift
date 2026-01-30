//
//  RegisterView.swift
//  Zadanie5
//
//  Created by Jakub Fedak on 16/01/2026.
//

import SwiftUI

struct RegisterView: View {
    @State private var username: String = ""
    @State private var password: String = ""
    @State private var firstName: String = ""
    @State private var lastName: String = ""
    @State private var email: String = ""
    
    @State private var showAlert: Bool = false
    @State private var alertMessage: String = ""
    @State private var shouldDismiss: Bool = false
    
    @EnvironmentObject var authService: AuthService
    
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Email:")
            TextField("Enter email", text: $email)
                .textInputAutocapitalization(.never)
        }
        .padding(.leading)
        .padding(.bottom, 10)
        
        VStack(alignment: .leading) {
            Text("First name:")
            TextField("Enter first name", text: $firstName)
                .textInputAutocapitalization(.words)
        }
        .padding(.leading)
        .padding(.bottom, 10)
        
        VStack(alignment: .leading) {
            Text("Last name:")
            TextField("Enter last name", text: $lastName)
                .textInputAutocapitalization(.words)
        }
        .padding(.leading)
        .padding(.bottom, 10)
        
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
                .textInputAutocapitalization(.never)
        }
        .padding(.leading)
        .padding(.bottom, 30)
        
        Button("Register") {
            Task {
                let result = await authService.registerWithServer(username: username, password: password, email: email, firstName: firstName, lastName: lastName)
                if result {
                    alertMessage = "Registered successfully"
                    shouldDismiss = true
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
                if shouldDismiss {
                    shouldDismiss = false
                    dismiss()
                }
            }
        }
    }
}

#Preview {
    RegisterView()
}
