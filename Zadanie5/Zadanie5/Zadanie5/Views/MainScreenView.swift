//
//  MainScreenView.swift
//  Zadanie5
//
//  Created by Jakub Fedak on 30/12/2025.
//

import SwiftUI
internal import Combine
import GoogleSignInSwift
import GoogleSignIn

struct MainScreenView: View {
    @EnvironmentObject var authService: AuthService
    
    var body: some View {
        NavigationStack {
            if authService.account != nil {
                AccountView()
            } else {
                VStack {
                    Text("Account not logged in")
                        .bold()
                        .padding(.bottom, 20)
                    
                    NavigationLink("Log in") {
                        LoginView()
                    }
                    .padding(5)
                    
                    NavigationLink("Register") {
                        RegisterView()
                    }
                    .padding(5)
                    
                    GoogleSignInButton(action: authService.signInWithGoogle)
                        .padding()
                }
            }
        }
    }
}

#Preview {
    MainScreenView()
}
