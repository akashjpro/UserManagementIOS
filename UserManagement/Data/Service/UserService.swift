//
//  UserService.swift
//  UserManagement
//
//  Created by Thanh Tri on 01/04/2025.
//

import Foundation
import OSLog

class UserService {
    private let baseURL = "https://67e685676530dbd311105148.mockapi.io/api/v1/user"
    private let logger = Logger(subsystem: "com.userManagement", category: "UserService")

    // MARK: - Fetch all users
    func fetchUsers() async throws -> [User] {
        guard let url = URL(string: baseURL) else {
            logger.error("Invalid URL: \(self.baseURL)")
            throw URLError(.badURL)
        }
        
        logger.info("Fetching users from \(url.absoluteString)")
        
        return try await performRequest(url: url)
    }

    // MARK: - Fetch user by ID
    func fetchUser(by id: String) async throws -> User {
        guard let url = URL(string: "\(baseURL)/\(id)") else {
            logger.error("Invalid URL: \(self.baseURL)/\(id)")
            throw URLError(.badURL)
        }
        
        logger.info("Fetching user from \(url.absoluteString)")
        
        return try await performRequest(url: url)
    }

    // MARK: - Add a new user
    func addUser(_ user: User) async throws -> User {
        guard let url = URL(string: baseURL) else { throw URLError(.badURL) }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try JSONEncoder().encode(user)

        return try await performRequest(urlRequest: request)
    }

    // MARK: - Update user
    func updateUser(_ user: User) async throws -> User {
        guard let id = user.id, let url = URL(string: "\(baseURL)/\(id)") else { throw URLError(.badURL) }

        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try JSONEncoder().encode(user)

        return try await performRequest(urlRequest: request)
    }

    // MARK: - Delete user
    func deleteUser(_ id: String) async throws -> User {
        guard let url = URL(string: "\(baseURL)/\(id)") else { throw URLError(.badURL) }

        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"

        return try await performRequest(urlRequest: request)
    }

    // MARK: - Generalized Request Handling
    private func performRequest<T: Decodable>(url: URL) async throws -> T {
        let request = URLRequest(url: url)
        return try await performRequest(urlRequest: request)
    }

    private func performRequest<T: Decodable>(urlRequest: URLRequest) async throws -> T {
        do {
            let (data, response) = try await URLSession.shared.data(for: urlRequest)
            logResponse(response: response, data: data)

            guard let httpResponse = response as? HTTPURLResponse else {
                throw NetworkError.invalidResponse
            }

            switch httpResponse.statusCode {
            case 200...299:
                return try JSONDecoder().decode(T.self, from: data)
            case 400:
                throw NetworkError.badRequest
            case 401:
                throw NetworkError.unauthorized
            case 403:
                throw NetworkError.forbidden
            case 404:
                throw NetworkError.notFound
            case 500:
                throw NetworkError.serverError
            default:
                throw NetworkError.unexpectedStatusCode(httpResponse.statusCode)
            }
        } catch let error as URLError {
            LogHelper.logInfo(category: "UserService", message: "handleNetworkError: \(error.localizedDescription)")
            throw handleNetworkError(error)
        } catch {
            logger.error("Decoding error: \(error.localizedDescription)")
            throw NetworkError.decodingError
        }
    }

    // MARK: - Handle Network Errors
    private func handleNetworkError(_ error: URLError) -> Error {
        switch error.code {
        case .notConnectedToInternet:
            return NetworkError.noInternet
        case .timedOut:
            return NetworkError.timeout
        case .networkConnectionLost:
            return NetworkError.connectionLost
        default:
            return error
        }
    }

    // MARK: - Log Responses
    private func logResponse(response: URLResponse, data: Data) {
        if let httpResponse = response as? HTTPURLResponse {
            logger.info("Response: \(httpResponse.statusCode) - \(String(data: data, encoding: .utf8) ?? "No Data")")
        }
    }
}


// MARK: - Define Network Errors
enum NetworkError: LocalizedError {
    case noInternet
    case timeout
    case connectionLost
    case invalidResponse
    case badRequest
    case unauthorized
    case forbidden
    case notFound
    case serverError
    case decodingError
    case unexpectedStatusCode(Int)

    var errorDescription: String? {
        switch self {
        case .noInternet:
            return "No Internet Connection. Please check your network settings."
        case .timeout:
            return "The request timed out. Please try again later."
        case .connectionLost:
            return "The network connection was lost. Please check your connection."
        case .invalidResponse:
            return "Received an invalid response from the server."
        case .badRequest:
            return "Bad request. Please check your input."
        case .unauthorized:
            return "Unauthorized access. Please log in again."
        case .forbidden:
            return "You do not have permission to access this resource."
        case .notFound:
            return "Requested resource was not found."
        case .serverError:
            return "Server encountered an error. Please try again later."
        case .decodingError:
            return "Failed to decode server response."
        case .unexpectedStatusCode(let code):
            return "Unexpected server response: \(code)"
        }
    }
}
