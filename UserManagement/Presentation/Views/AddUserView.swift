//
//  AddUserView.swift
//  UserManagement
//
//  Created by Thanh Tri on 01/04/2025.
//

import SwiftUI


struct AddUserView: View {
    @ObservedObject var viewModel: UserViewModel
    @State private var firstName = ""
    @State private var lastName = ""
    @State private var age: Int = 0  // Changed to Int?
    @State private var address = ""
    @State private var male = true
    @State private var birthday = Date() // Store birthday as Date
    
    // Environment variable to dismiss the current view
    @Environment(\.presentationMode) var presentationMode
    
    // State variables for loading and error handling
    @State private var isLoading = false
    @State private var showError = false
    
    var body: some View {
        Form {
            TextField("First Name", text: $firstName)
            TextField("Last Name", text: $lastName)
            TextField("Age", value:  $age, formatter: numberFormatter)
                .keyboardType(.numberPad)
            TextField("Address", text: $address)
            
            // Toggle field to edit gender (male)
            Toggle("Male", isOn: $male)
            
            // DatePicker for birthday; it directly uses the Date type
            DatePicker("Birthday", selection: $birthday, displayedComponents: .date)
            
            // Show a loading indicator if API call is in progress
            if isLoading {
                ProgressView()
                    .padding()
            }
            
            Button("Save") {
                Task {
                    isLoading = true  // Start loading
                    let newUser = User(
                        id: nil,
                        first_name: firstName,
                        last_name: lastName,
                        age: age ?? 0,  // Use optional binding
                        male: male,
                        address: address,
                        birthday: Int(birthday.timeIntervalSince1970)
                    )
                    
                    do {
                        try await viewModel.addUser(newUser)
                        isLoading = false  // Stop loading on success
                        // Dismiss the view to return to the List User screen
                        presentationMode.wrappedValue.dismiss()
                    } catch {
                        isLoading = false  // Stop loading on error
                        // If adding fails, show an error alert
                        showError = true
                    }
                }
            }
            .disabled(isLoading)  // Disable the button while loading
        }
        .navigationTitle("Add User")
        .alert(isPresented: $showError) {
            Alert(title: Text("Error"),
                  message: Text("Failed to add user"),
                  dismissButton: .default(Text("OK")))
        }
    }
}

private var numberFormatter: NumberFormatter {
    let formatter = NumberFormatter()
    formatter.numberStyle = .decimal
    formatter.zeroSymbol = ""
    formatter.allowsFloats = false
    return formatter
}


//struct AddUserView_Previews: PreviewProvider {
//    static var previews: some View {
//        AddUserView()
//    }
//}
