//
//  EditUserView.swift
//  UserManagement
//
//  Created by Thanh Tri on 01/04/2025.
//

import SwiftUI

// EditUserView.swift
struct EditUserView: View {
    @ObservedObject var viewModel: UserViewModel
    @State var user: User
    @State private var showError = false

    var body: some View {
        Form {
            TextField("First Name", text: $user.first_name)
            TextField("Last Name", text: $user.last_name)
            TextField("Age", value: $user.age, formatter: NumberFormatter())
            TextField("Address", text: $user.address)
            
            // Toggle field to edit gender (male)
            Toggle("Male", isOn: $user.male)
            
            // DatePicker for birthday with binding conversion from Int to Date
            DatePicker("Birthday", selection: Binding<Date>(
                get: {
                    Date(timeIntervalSince1970: TimeInterval(user.birthday))
                },
                set: {
                    user.birthday = Int($0.timeIntervalSince1970)
                }
            ), displayedComponents: .date)
            
            if viewModel.isLoading {
                ProgressView()
            }
            
            Button("Save") {
                if user.first_name.isEmpty || user.last_name.isEmpty || user.address.isEmpty {
                    showError = true
                } else {
                    Task {
                        await viewModel.updateUser(user)
                    }
                }
            }
            .alert(isPresented: $showError) {
                Alert(title: Text("Error"),
                      message: Text("All fields are required"),
                      dismissButton: .default(Text("OK")))
            }
        }
        .navigationTitle("Edit User")
    }
}

//struct EditUserView_Previews: PreviewProvider {
//    static var previews: some View {
//       // EditUserView(viewModel: <#UserViewModel#>, user: <#User#>)
//    }
//}
