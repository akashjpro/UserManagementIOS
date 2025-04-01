//
//  UserListView.swift
//  UserManagement
//
//  Created by Thanh Tri on 01/04/2025.
//

import SwiftUI

struct UserListView: View {
    @StateObject private var viewModel = UserViewModel()
    
    var body: some View {
        NavigationView {
            VStack {
                if viewModel.isLoading {
                    // Show loading indicator
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle())
                        .padding()
                } else {
                    List {
                        ForEach(viewModel.users) { user in
                            NavigationLink(destination: UserDetailView(user: user, viewModel: viewModel)) {
                                VStack(alignment: .leading) {
                                    Text("\(user.first_name) \(user.last_name)")
                                        .font(.headline)
                                    Text(user.address)
                                        .font(.subheadline)
                                }
                            }
                        }
                        .onDelete { indexSet in
                            Task {
                                if let index = indexSet.first {
                                    // Get the user id before calling the async function
                                    let userId = viewModel.users[index].id
                                    await viewModel.deleteUser(userId!)
                                }
                            }
                        }
                    }
                }
            }
            
            // Pull to refresh: Call loadUsers when the list is pulled down
            .refreshable {
                await viewModel.loadUsers()
            }
            .task {
                await viewModel.loadUsers()
            }
            .navigationTitle("Users")
            .toolbar {
                NavigationLink("Add User", destination: AddUserView(viewModel: viewModel))
            }
        }
    }
}
