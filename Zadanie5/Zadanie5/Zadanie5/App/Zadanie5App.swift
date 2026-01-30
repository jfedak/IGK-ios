//
//  Zadanie5App.swift
//  Zadanie5
//
//  Created by Jakub Fedak on 30/12/2025.
//

import SwiftUI

@main
struct Zadanie5App: App {
    @StateObject var authService = AuthService()
    
    var body: some Scene {
        WindowGroup {
            MainScreenView()
                .environmentObject(authService)
        }
    }
}
