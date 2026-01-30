//
//  AccountView.swift
//  Zadanie5
//
//  Created by Jakub Fedak on 16/01/2026.
//

import SwiftUI
import GoogleSignIn

struct AccountView: View {
    @EnvironmentObject var authService: AuthService
    
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        if authService.account != nil {
            VStack {
                switch authService.loginMethod {
                case .Server:
                    Text("Logged using local server")
                        .bold()
                        .padding()
                case .Google:
                    Text("Logged using Google OAuth2")
                        .bold()
                        .padding()
                case .Github:
                    Text("Logged using Github OAuth2")
                        .bold()
                        .padding()
                case .none:
                    Text("")
                }
                
                if authService.account!.username != nil {
                    Text("Username: \(authService.account!.username!)")
                }
                Text("Email: \(authService.account!.email)")
                Text("First name: \(authService.account!.firstName)")
                Text("Last name: \(authService.account!.lastName)")
                Button("Log out") {
                    authService.signOut()
                    dismiss()
                }
                .padding()
            }
        }
    }
}
