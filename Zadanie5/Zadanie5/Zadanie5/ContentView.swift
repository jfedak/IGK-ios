//
//  ContentView.swift
//  Zadanie5
//
//  Created by Jakub Fedak on 30/12/2025.
//

import SwiftUI
internal import Combine

class Account: ObservableObject {
    @Published var isLoggedIn: Bool = false
    @Published var username: String = ""
    @Published var email: String = ""
    
    func logIn(username: String, email: String) {
        isLoggedIn = true
        self.username = username
        self.email = email
    }
    
    func logOut() {
        isLoggedIn = false
        username = ""
        email = ""
    }
}

struct ContentView: View {
    @StateObject var account = Account()
    @State var username: String = ""
    @State var password: String = ""
    @State var showAlert: Bool = false
    
    var body: some View {
        if account.isLoggedIn {
            VStack {
                Text("Username: \(account.username)")
                Text("Email: \(account.email)")
                Button("Log out") {
                    account.logOut()
                }
            }
        } else {
            VStack {
                Text("Please log in")
                    .bold()
                    .padding(.bottom, 30)
                
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
                    login(username: username, password: password)
                    print(showAlert)
                }
                .padding(.bottom, 30)
                
                if showAlert {
                    Text("Unable to log in")
                }
            }
        }
    }
    
    struct LoginData: Codable {
        let username: String
        let password: String
    }
    
    struct LoginResponse: Codable {
        let username: String
        let email: String
    }
    
    func login(username: String, password: String) {
        guard let url = URL(string: "http://127.0.0.1:8000/login") else {
            self.showAlert = true
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body = LoginData(username: username, password: password)
        let encoder = JSONEncoder()
        do {
            request.httpBody = try encoder.encode(body)
        } catch {
            self.showAlert = true
            return
        }
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard error == nil, let data = data  else {
                self.showAlert = true
                return
            }
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                self.showAlert = true
                return
            }
            do {
                let decodedData = try JSONDecoder().decode(LoginResponse.self, from: data)
                print(decodedData)
                self.account.logIn(username: decodedData.username, email: decodedData.email)
                self.showAlert = false
            } catch {
                self.showAlert = true
                return
            }
        }.resume()
    }
}

#Preview {
    ContentView()
}
