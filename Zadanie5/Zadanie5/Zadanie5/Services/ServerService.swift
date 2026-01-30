//
//  ServerLoginHelper.swift
//  Zadanie5
//
//  Created by Jakub Fedak on 13/01/2026.
//

import SwiftUI

enum ServerError: Error {
    case incorrectURL
    case incorrectData
    case incorrectResponse
    case incorrectCredentials
    case parsingJSONError
    case userAlreadyExistsError
    case responseErrorCode(code: Int)
}

extension ServerError: LocalizedError {
    var errorDescription: String? {
        switch self {
            case .incorrectURL:
                "Server URL is incorrect"
            case .incorrectData:
                "Provided data cannot be sent to a server"
            case .incorrectResponse:
                "Server response was incorrect"
            case .parsingJSONError:
                "Error while parsing JSON response"
            case .incorrectCredentials:
                "Incorrect username or password"
            case .userAlreadyExistsError:
                "User with that username or email already exists"
            case .responseErrorCode(code: let code):
                "Error. Server responded with code: \(code)"
        }
    }
}

enum ServerService {
    private struct LoginData: Codable {
        let username: String
        let password: String
    }

    private struct LoginResponse: Codable {
        let username: String
        let email: String
        let firstName: String
        let lastName: String
    }
    
    private struct RegisterData: Codable {
        let username: String
        let password: String
        let email: String
        let firstName: String
        let lastName: String
    }
    
    private struct RegisterResponse: Codable {
        let message: String
    }
    
    static func signIn(username: String, password: String) async throws -> AuthService.Account {
        var request = try prepareRequest("http://127.0.0.1:8000/login")
        
        let body = LoginData(username: username, password: password)
        request = try parseRequestData(request, body)
        let data = try await callServer(request)
        
        do {
            let decodedData = try JSONDecoder().decode(LoginResponse.self, from: data)
            return AuthService.Account(username: decodedData.username, email: decodedData.email,
                                       firstName: decodedData.firstName, lastName: decodedData.lastName)
        } catch {
            throw ServerError.parsingJSONError
        }
    }
    
    
    static func register(username: String, password: String, email: String, firstName: String, lastName: String) async throws -> Bool {
        var request = try prepareRequest("http://127.0.0.1:8000/register")
        
        let body = RegisterData(username: username, password: password, email: email, firstName: firstName, lastName: lastName)
        request = try parseRequestData(request, body)
        let data = try await callServer(request)
        
        do {
            let _ = try JSONDecoder().decode(RegisterResponse.self, from: data)
            return true
        } catch {
            throw ServerError.parsingJSONError
        }
    }
    
    private static func callServer(_ request: URLRequest) async throws -> Data {
        let data: Data
        let response: URLResponse
        
        do {
            (data, response) = try await URLSession.shared.data(for: request)
        } catch {
            throw ServerError.incorrectResponse
        }
        guard let httpResponse = response as? HTTPURLResponse else {
            throw ServerError.incorrectResponse
        }
        if httpResponse.statusCode == 401 {
            throw ServerError.incorrectCredentials
        } else if httpResponse.statusCode == 409 {
            throw ServerError.userAlreadyExistsError
        }
        guard httpResponse.statusCode == 200 else {
            throw ServerError.responseErrorCode(code: httpResponse.statusCode)
        }
        
        return data
    }
    
    private static func prepareRequest(_ urlString: String) throws -> URLRequest {
        guard let url = URL(string: urlString) else {
            throw ServerError.incorrectURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        return request
    }
    
    private static func parseRequestData<T: Codable>(_ request: URLRequest, _ body: T) throws -> URLRequest {
        var resultRequest = request
        let encoder = JSONEncoder()
        do {
            resultRequest.httpBody = try encoder.encode(body)
            return resultRequest
        } catch {
            throw ServerError.incorrectData
        }
    }
}
