//
//  Resource.swift
//  UserManagement
//
//  Created by Thanh Tri on 01/04/2025.
//

import Foundation

enum Resource<T> {
    case loading
    case success(T)
    case failure(Error)
}

func handleUserResource(_ resource: Resource<User>) {
    switch resource {
    case .loading:
        print("Loading user...")
    case .success(let user):
        print("Received user: \(user)")
    case .failure(let error):
        print("Error fetching user: \(error.localizedDescription)")
    }
}
