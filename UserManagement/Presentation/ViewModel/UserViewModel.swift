//
//  UserViewModel.swift
//  UserManagement
//
//  Created by Thanh Tri on 01/04/2025.
//

import Foundation

@MainActor
class UserViewModel: ObservableObject {
    @Published var users: [User] = []
    @Published var selectedUser: User?
    @Published var isLoading = false
    @Published var errorMessage: String?
    private let userUsecase = UserUsecase(userRepository: UserRepository(userService: UserService()))
    
    
    func loadUsers() async {
        isLoading = true
        
        await userUsecase.fetchUsers().handle {
            isLoading = true
        } successAction: { listUser in
            isLoading = false
            users = listUser
        } failureAction: { error in
            isLoading = false
            errorMessage = "Error loading user: \(error.localizedDescription)"
            
        }
        
    }
    
    func loadUser(by id: String) async {
        isLoading = true
        await userUsecase.fetchUser(by: id).handle {
            isLoading = true
        } successAction: { user in
            isLoading = false
            selectedUser = user
        } failureAction: { error in
            isLoading = false
            errorMessage = "Error loading user: \(error.localizedDescription)"
            
        }
    }
    
    func addUser(_ user: User) async {
        isLoading = true
        await userUsecase.addUser(user).handle(
            loadingAction: {
                isLoading = true
            },
            successAction: { user in
                isLoading = false
                selectedUser = user
            },
            failureAction:  { error in
                isLoading = false
                errorMessage = "Error loading user: \(error.localizedDescription)"
            }
        )
        
    }
    
    func updateUser(_ user: User) async {
        isLoading = true
        await userUsecase.updateUser(user).handle(
            loadingAction: {
                isLoading = true
            },
            successAction: { user in
                selectedUser = user
                Task {
                    await loadUsers()
                }
                
            },
            failureAction:  { error in
                isLoading = false
                errorMessage = "Error loading user: \(error.localizedDescription)"
            }
        )
        
    }
    
    func deleteUser(_ id: String) async {
        isLoading = true
        
        await userUsecase.deleteUser(id).handle(
            loadingAction: {
                isLoading = true
            },
            successAction: { user in
                selectedUser = user
                
                Task {
                    await loadUsers()
                }
                
            },
            failureAction:  { error in
                isLoading = false
                errorMessage = "Error loading user: \(error.localizedDescription)"
            }
        )
    }
}
