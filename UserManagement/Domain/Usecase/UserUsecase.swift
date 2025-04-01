//
//  UserUsecase.swift
//  UserManagement
//
//  Created by Thanh Tri on 01/04/2025.
//

import Foundation

protocol UserUsecaseProtocol {
    func fetchUsers() async -> Resource<[User]>
    
    func fetchUser(by id: String) async -> Resource<User>
    
    func addUser(_ user: User) async -> Resource<User>
    
    func updateUser(_ user: User) async -> Resource<User>
    
    func deleteUser(_ id: String) async -> Resource<User>
}

class UserUsecase {
    private let userRepository: UserRepositoryProtocol
    
    init(userRepository: UserRepositoryProtocol) {
        self.userRepository = userRepository
    }
}

extension UserUsecase : UserUsecaseProtocol {
    func fetchUsers() async -> Resource<[User]> {
        return await userRepository.fetchUsers()
    }
    
    func fetchUser(by id: String) async -> Resource<User> {
        return await userRepository.fetchUser(by: id)
    }
    
    func addUser(_ user: User) async -> Resource<User> {
        return await userRepository.addUser(user)
    }
    
    func updateUser(_ user: User) async -> Resource<User> {
        return await userRepository.updateUser(user)
    }
    
    func deleteUser(_ id: String) async -> Resource<User> {
        return await userRepository.deleteUser(id)
    }
}
