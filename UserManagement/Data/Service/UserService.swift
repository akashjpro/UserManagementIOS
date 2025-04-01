//
//  UserService.swift
//  UserManagement
//
//  Created by Thanh Tri on 01/04/2025.
//

import Foundation
import os.log

class UserService {
    private let baseURL = "https://67e685676530dbd311105148.mockapi.io/api/v1/user"
    private let logger = Logger(subsystem: "com.yourapp.network", category: "UserService")
    
    func fetchUsers() async throws -> [User] {
        guard let url = URL(string: baseURL) else {
            logger.error("Invalid URL: \(self.baseURL)")
            throw URLError(.badURL)
        }
        
        logger.info("Fetching users from \(url.absoluteString)")
        
        do {
            let (data, response) = try await URLSession.shared.data(from: url)
            logResponse(response: response, data: data)
            return try JSONDecoder().decode([User].self, from: data)
        } catch {
            logger.error("Fetch users failed: \(error.localizedDescription)")
            throw error
        }
    }
    
    func fetchUser(by id: String) async throws -> User {
        guard let url = URL(string: "\(baseURL)/\(id)") else { throw URLError(.badURL) }
        
        logger.info("Fetching users from \(url.absoluteString)")
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            return try JSONDecoder().decode(User.self, from: data)
        } catch let error as URLError {
            throw handleNetworkError(error)
        }
    }
    
    func addUser(_ user: User) async throws -> User {
        guard let url = URL(string: baseURL) else { throw URLError(.badURL) }
        
        logger.info("Fetching users from \(url.absoluteString)")
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try JSONEncoder().encode(user)
        
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            
            guard (response as? HTTPURLResponse)?.statusCode == 201 else { throw URLError(.badServerResponse) }
            
            return try JSONDecoder().decode(User.self, from: data)
            
        } catch let error as URLError {
            throw handleNetworkError(error)
        }
    }
    
    func updateUser(_ user: User) async throws -> User {
        guard let id = user.id, let url = URL(string: "\(baseURL)/\(id)") else { throw URLError(.badURL) }
        
        logger.info("Fetching users from \(url.absoluteString)")
        
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try JSONEncoder().encode(user)
        
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            guard (response as? HTTPURLResponse)?.statusCode == 200 else { throw URLError(.badServerResponse) }
            
            return try JSONDecoder().decode(User.self, from: data)
            
        } catch let error as URLError {
            throw handleNetworkError(error)
        }
    }
    
    func deleteUser(_ id: String) async throws -> User {
        guard let url = URL(string: "\(baseURL)/\(id)") else { throw URLError(.badURL) }
        logger.info("Fetching users from \(url.absoluteString)")
        
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            guard (response as? HTTPURLResponse)?.statusCode == 200 else { throw URLError(.badServerResponse) }
            
            return try JSONDecoder().decode(User.self, from: data)
            
        } catch let error as URLError {
            throw handleNetworkError(error)
        }
    }
    
    private func handleNetworkError(_ error: URLError) -> Error {
        switch error.code {
        case .notConnectedToInternet:
            return NSError(domain: "NetworkError", code: error.code.rawValue, userInfo: [NSLocalizedDescriptionKey: "No Internet Connection"])
        case .timedOut:
            return NSError(domain: "NetworkError", code: error.code.rawValue, userInfo: [NSLocalizedDescriptionKey: "Request Timed Out"])
        default:
            return error
        }
    }
    
    private func logResponse(response: URLResponse, data: Data) {
        if let httpResponse = response as? HTTPURLResponse {
            logger.info("Response: \(httpResponse.statusCode) - \(String(data: data, encoding: .utf8) ?? "No Data")")
        }
    }
}
