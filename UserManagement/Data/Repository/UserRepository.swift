//
//  UserRepository.swift
//  UserManagement
//
//  Created by Thanh Tri on 01/04/2025.
//

import Foundation

protocol UserRepositoryProtocol {
    func fetchUsers() async -> Resource<[User]>
    
    func fetchUser(by id: String) async -> Resource<User>
    
    func addUser(_ user: User) async -> Resource<User>
    
    func updateUser(_ user: User) async -> Resource<User>
    
    func deleteUser(_ id: String) async -> Resource<User>
}

class UserRepository {
    private let userService: UserService
    
    init(userService: UserService) {
        self.userService = userService
    }
}

extension UserRepository : UserRepositoryProtocol {
    func fetchUsers() async -> Resource<[User]> {
        do {
            let data =  try await userService.fetchUsers()
            return Resource.success(data)
        } catch {
            return Resource.failure(error)
        }
    }
    
    func fetchUser(by id: String) async -> Resource<User> {
        do {
            let data =  try await userService.fetchUser(by: id)
            return Resource.success(data)
        } catch {
            return Resource.failure(error)
        }
    }
    
    func addUser(_ user: User) async -> Resource<User> {
        do {
            let data = try await userService.addUser(user)
            return Resource.success(data)
        } catch {
            return Resource.failure(error)
        }
    }
    
    func updateUser(_ user: User) async -> Resource<User> {
        do {
            let data = try await userService.updateUser(user)
            return Resource.success(data)
        } catch {
            return Resource.failure(error)
        }
    }
    
    func deleteUser(_ id: String) async -> Resource<User> {
        do {
            let data = try await userService.deleteUser(id)
            return Resource.success(data)
        } catch {
            return Resource.failure(error)
        }
    }
}
