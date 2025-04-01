//
//  User.swift
//  UserManagement
//
//  Created by Thanh Tri on 01/04/2025.
//

import Foundation

struct User: Identifiable, Codable {
    var id: String?
    var first_name: String
    var last_name: String
    var age: Int
    var male: Bool
    var address: String
    var birthday: Int
}
