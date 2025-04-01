//
//  Resource+Extension.swift
//  UserManagement
//
//  Created by Thanh Tri on 01/04/2025.
//

import Foundation
extension Resource {
    func handle(loadingAction: () -> Void, successAction: (T) -> Void, failureAction: (Error) -> Void) {
        switch self {
        case .loading:
            loadingAction()
        case .success(let data):
            successAction(data)
        case .failure(let error):
            failureAction(error)
        }
    }
}

extension Resource where T == [User] {
    func handle(loadingAction: () -> Void, successAction: ([User]) -> Void, failureAction: (Error) -> Void) {
        switch self {
        case .loading:
            loadingAction()
        case .success(let users):
            successAction(users)
        case .failure(let error):
            failureAction(error)
        }
    }
}


extension Resource where T == User {
    func handle(loadingAction: () -> Void, successAction: (User) -> Void, failureAction: (Error) -> Void) {
        switch self {
        case .loading:
            loadingAction()
        case .success(let user):
            successAction(user)
        case .failure(let error):
            failureAction(error)
        }
    }
}
