//
//  AuthService.swift
//  Zadanie5
//
//  Created by Jakub Fedak on 17/01/2026.
//

import SwiftUI
internal import Combine

@MainActor
class AuthService: ObservableObject {
    struct Account {
        let username: String?
        let email: String
        let firstName: String
        let lastName: String
    }
    
    enum LoginMethod {
        case Server
        case Google
        case Github
    }
    
    @Published var account: Account?
    @Published var loginMethod: LoginMethod?
    @Published var alertMessage: String?
    
    func signInWithGoogle() {
        alertMessage = nil
        Task {
            do {
                let account = try await GoogleService.signIn()
                self.account = account
                self.loginMethod = .Google
            } catch {
                alertMessage = error.localizedDescription
            }
        }
    }
    
    func signInWithServer(username: String, password: String) async -> Bool {
        alertMessage = nil
        do {
            let account = try await ServerService.signIn(username: username, password: password)
            self.account = account
            self.loginMethod = .Server
            return true
        } catch {
            alertMessage = error.localizedDescription
            return false
        }
    }
    
    func registerWithServer(username: String, password: String, email: String, firstName: String, lastName: String) async -> Bool {
        alertMessage = nil
        
        guard isEmailValid(email) else {
            alertMessage = "Invalid email"
            return false
        }
        
        do {
            let _ = try await ServerService.register(username: username, password: password, email: email, firstName:firstName, lastName: lastName)
            return true
        } catch {
            alertMessage = error.localizedDescription
            return false
        }
    }
    
    func signOut() {
        switch loginMethod {
        case .none:
            break
        case .Server:
            break
        case .Google:
            signOutWithGoogle()
        case .Github:
            break
        }
        
        clearData()
    }
    
    private func signOutWithGoogle() {
        GoogleService.signOut()
    }
    
    private func clearData() {
        account = nil
        loginMethod = nil
        alertMessage = nil
    }
    
    private func isEmailValid(_ email: String) -> Bool {
        let emailRegex = /[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,64}/
        return email.wholeMatch(of: emailRegex) != nil
    }
}
