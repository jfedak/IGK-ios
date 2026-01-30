//
//  ServerLoginHelper.swift
//  Zadanie4
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
    private struct AddProductData: Codable {
        let category_id: Int64
        let name: String
        let price: Double
        let description: String
    }
    
    private struct AddProductResponse: Codable {
        let id: Int64
    }
    
    static func addProduct(categoryId: Int64, name: String, price: Double, description: String) async throws -> Int64 {
        var request = try prepareRequest("http://127.0.0.1:8000/add_product")
        var body = AddProductData(category_id: categoryId, name: name, price: price, description: description)
        request = try parseRequestData(request, body)
        let data = try await callServer(request)
        
        do {
            let response = try JSONDecoder().decode(AddProductResponse.self, from: data)
            return response.id
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
