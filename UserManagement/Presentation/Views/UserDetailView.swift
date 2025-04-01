//
//  UserDetailView.swift
//  UserManagement
//
//  Created by Thanh Tri on 01/04/2025.
//

import SwiftUI
struct UserDetailView: View {
    var user: User
    @ObservedObject var viewModel: UserViewModel
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("\(user.first_name) \(user.last_name)")
                .font(.largeTitle)
            Text("Age: \(user.age)")
            Text("Gender: \(user.male ? "Male" : "Female")")
            Text("Address: \(user.address)")
            Text("Birthday: \(Date(timeIntervalSince1970: TimeInterval(user.birthday)))")
            
            Spacer()
            
            NavigationLink("Edit User", destination: EditUserView(viewModel: viewModel, user: user))
                .frame(maxWidth: .infinity, alignment: .center)
        }
        .padding()
        .navigationTitle("User Detail")
    }
}
