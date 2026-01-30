//
//  GoogleService.swift
//  Zadanie5
//
//  Created by Jakub Fedak on 17/01/2026.
//

import SwiftUI
import GoogleSignIn

enum GoogleServiceError: Error {
    case noRootViewController
    case noUserFound
}

extension GoogleServiceError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .noRootViewController:
            "Cannot find rootViewController"
        case .noUserFound:
            "Cannot find user"
        }
    }
}

enum GoogleService {
    @MainActor
    static func signIn() async throws -> AuthService.Account {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let rootViewController = windowScene.windows.first?.rootViewController else {
            throw GoogleServiceError.noRootViewController
        }

        let result = try await GIDSignIn.sharedInstance.signIn(withPresenting: rootViewController)
        let user = result.user
        let account = AuthService.Account(
            username: nil,
            email: user.profile?.email ?? "No email found",
            firstName: user.profile?.givenName ?? "No first name found",
            lastName: user.profile?.familyName ?? "No last name found"
        )
        
        return account
    }
    
    static func signOut()  {
        GIDSignIn.sharedInstance.signOut()
    }
}
