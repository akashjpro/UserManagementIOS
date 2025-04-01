////
////  ContentView.swift
////  UserManagement
////
////  Created by Thanh Tri on 31/03/2025.
////
//
//import SwiftUI
//import Combine
//
//struct ContentView: View {
//    var body: some View {
//        UserListView()
//    }
//}
//
//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        ContentView()
//    }
//}
//
//
//
//struct User: Identifiable, Codable {
//    var id: String?
//    var first_name: String
//    var last_name: String
//    var age: Int
//    var male: Bool
//    var address: String
//    var birthday: Int
//}
//
//class UserService {
//    private let baseURL = "https://67e685676530dbd311105148.mockapi.io/api/v1/user"
//
//    func fetchUsers() async throws -> [User] {
//        guard let url = URL(string: baseURL) else { throw URLError(.badURL) }
//        do {
//            let (data, _) = try await URLSession.shared.data(from: url)
//            return try JSONDecoder().decode([User].self, from: data)
//        } catch let error as URLError {
//            throw handleNetworkError(error)
//        }
//    }
//
//    func fetchUser(by id: String) async throws -> User {
//        guard let url = URL(string: "\(baseURL)/\(id)") else { throw URLError(.badURL) }
//        do {
//            let (data, _) = try await URLSession.shared.data(from: url)
//            return try JSONDecoder().decode(User.self, from: data)
//        } catch let error as URLError {
//            throw handleNetworkError(error)
//        }
//    }
//
//    func addUser(_ user: User) async throws {
//        guard let url = URL(string: baseURL) else { throw URLError(.badURL) }
//        var request = URLRequest(url: url)
//        request.httpMethod = "POST"
//        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
//        request.httpBody = try JSONEncoder().encode(user)
//
//        do {
//            let (_, response) = try await URLSession.shared.data(for: request)
//            guard (response as? HTTPURLResponse)?.statusCode == 201 else { throw URLError(.badServerResponse) }
//        } catch let error as URLError {
//            throw handleNetworkError(error)
//        }
//    }
//
//    func updateUser(_ user: User) async throws {
//        guard let id = user.id, let url = URL(string: "\(baseURL)/\(id)") else { throw URLError(.badURL) }
//        var request = URLRequest(url: url)
//        request.httpMethod = "PUT"
//        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
//        request.httpBody = try JSONEncoder().encode(user)
//
//        do {
//            let (_, response) = try await URLSession.shared.data(for: request)
//            guard (response as? HTTPURLResponse)?.statusCode == 200 else { throw URLError(.badServerResponse) }
//        } catch let error as URLError {
//            throw handleNetworkError(error)
//        }
//    }
//
//    func deleteUser(_ id: String) async throws {
//        guard let url = URL(string: "\(baseURL)/\(id)") else { throw URLError(.badURL) }
//        var request = URLRequest(url: url)
//        request.httpMethod = "DELETE"
//
//        do {
//            let (_, response) = try await URLSession.shared.data(for: request)
//            guard (response as? HTTPURLResponse)?.statusCode == 200 else { throw URLError(.badServerResponse) }
//        } catch let error as URLError {
//            throw handleNetworkError(error)
//        }
//    }
//
//    private func handleNetworkError(_ error: URLError) -> Error {
//        switch error.code {
//        case .notConnectedToInternet:
//            return NSError(domain: "NetworkError", code: error.code.rawValue, userInfo: [NSLocalizedDescriptionKey: "No Internet Connection"])
//        case .timedOut:
//            return NSError(domain: "NetworkError", code: error.code.rawValue, userInfo: [NSLocalizedDescriptionKey: "Request Timed Out"])
//        default:
//            return error
//        }
//    }
//}
//
//@MainActor
//class UserViewModel: ObservableObject {
//    @Published var users: [User] = []
//    @Published var selectedUser: User?
//    @Published var isLoading = false
//    @Published var errorMessage: String?
//    private let userService = UserService()
//
//
//    func loadUsers() async {
//        isLoading = true
//        defer { isLoading = false }
//        do {
//            self.users = try await userService.fetchUsers()
//        } catch {
//            errorMessage = "Error loading users: \(error.localizedDescription)"
//        }
//    }
//
//    func loadUser(by id: String) async {
//        isLoading = true
//        defer { isLoading = false }
//        do {
//            self.selectedUser = try await userService.fetchUser(by: id)
//        } catch {
//            errorMessage = "Error loading user: \(error.localizedDescription)"
//        }
//    }
//
//    func addUser(_ user: User) async {
//        isLoading = true
//        defer { isLoading = false }
//        do {
//            try await userService.addUser(user)
//            await loadUsers()
//        } catch {
//            errorMessage = "Error adding user: \(error.localizedDescription)"
//        }
//    }
//
//    func updateUser(_ user: User) async {
//        isLoading = true
//        defer { isLoading = false }
//        do {
//            try await userService.updateUser(user)
//            await loadUsers()
//        } catch {
//            errorMessage = "Error updating user: \(error.localizedDescription)"
//        }
//    }
//
//    func deleteUser(_ id: String) async {
//        isLoading = true
//        defer { isLoading = false }
//        do {
//            try await userService.deleteUser(id)
//            users.removeAll { $0.id == id }
//        } catch {
//            errorMessage = "Error deleting user: \(error.localizedDescription)"
//        }
//    }
//}
//
//struct UserListView: View {
//    @StateObject private var viewModel = UserViewModel()
//
//    var body: some View {
//        NavigationView {
//            List {
//                ForEach(viewModel.users) { user in
//                    NavigationLink(destination: UserDetailView(user: user, viewModel: viewModel)) {
//                        VStack(alignment: .leading) {
//                            Text("\(user.first_name) \(user.last_name)")
//                                .font(.headline)
//                            Text(user.address)
//                                .font(.subheadline)
//                        }
//                    }
//                }
//                .onDelete { indexSet in
//                    Task {
//                        if let index = indexSet.first {
//                            // Get the user id before calling the async function
//                            let userId = viewModel.users[index].id
//                            await viewModel.deleteUser(userId!)
//                        }
//                    }
//                }
//            }
//            // Pull to refresh: Call loadUsers when the list is pulled down
//            .refreshable {
//                await viewModel.loadUsers()
//            }
//            .task {
//                await viewModel.loadUsers()
//            }
//            .navigationTitle("Users")
//            .toolbar {
//                NavigationLink("Add User", destination: AddUserView(viewModel: viewModel))
//            }
//        }
//    }
//}
//
//struct UserDetailView: View {
//    var user: User
//    @ObservedObject var viewModel: UserViewModel
//
//    var body: some View {
//        VStack(alignment: .leading) {
//            Text("\(user.first_name) \(user.last_name)")
//                .font(.largeTitle)
//            Text("Age: \(user.age)")
//            Text("Gender: \(user.male ? "Male" : "Female")")
//            Text("Address: \(user.address)")
//            Text("Birthday: \(Date(timeIntervalSince1970: TimeInterval(user.birthday)))")
//
//            Spacer()
//
//            NavigationLink("Edit User", destination: EditUserView(viewModel: viewModel, user: user))
//                .frame(maxWidth: .infinity, alignment: .center)
//        }
//        .padding()
//        .navigationTitle("User Detail")
//    }
//}
//
//// EditUserView.swift
//struct EditUserView: View {
//    @ObservedObject var viewModel: UserViewModel
//    @State var user: User
//    @State private var showError = false
//
//    var body: some View {
//        Form {
//            TextField("First Name", text: $user.first_name)
//            TextField("Last Name", text: $user.last_name)
//            TextField("Age", value: $user.age, formatter: NumberFormatter())
//            TextField("Address", text: $user.address)
//
//            // Toggle field to edit gender (male)
//            Toggle("Male", isOn: $user.male)
//
//            // DatePicker for birthday with binding conversion from Int to Date
//            DatePicker("Birthday", selection: Binding<Date>(
//                get: {
//                    Date(timeIntervalSince1970: TimeInterval(user.birthday))
//                },
//                set: {
//                    user.birthday = Int($0.timeIntervalSince1970)
//                }
//            ), displayedComponents: .date)
//
//            if viewModel.isLoading {
//                ProgressView()
//            }
//
//            Button("Save") {
//                if user.first_name.isEmpty || user.last_name.isEmpty || user.address.isEmpty {
//                    showError = true
//                } else {
//                    Task {
//                        await viewModel.updateUser(user)
//                    }
//                }
//            }
//            .alert(isPresented: $showError) {
//                Alert(title: Text("Error"),
//                      message: Text("All fields are required"),
//                      dismissButton: .default(Text("OK")))
//            }
//        }
//        .navigationTitle("Edit User")
//    }
//}
//
//struct AddUserView: View {
//    @ObservedObject var viewModel: UserViewModel
//    @State private var firstName = ""
//    @State private var lastName = ""
//    @State private var age: Int? = nil  // Changed to Int?
//    @State private var address = ""
//    @State private var male = true
//    @State private var birthday = Date() // Store birthday as Date
//
//    // Environment variable to dismiss the current view
//    @Environment(\.presentationMode) var presentationMode
//
//    // State variables for loading and error handling
//    @State private var isLoading = false
//    @State private var showError = false
//
//    var body: some View {
//        Form {
//            TextField("First Name", text: $firstName)
//            TextField("Last Name", text: $lastName)
//            TextField("Age", value: $age, formatter: NumberFormatter())
//            TextField("Address", text: $address)
//
//            // Toggle field to edit gender (male)
//            Toggle("Male", isOn: $male)
//
//            // DatePicker for birthday; it directly uses the Date type
//            DatePicker("Birthday", selection: $birthday, displayedComponents: .date)
//
//            // Show a loading indicator if API call is in progress
//            if isLoading {
//                ProgressView()
//                    .padding()
//            }
//
//            Button("Save") {
//                Task {
//                    isLoading = true  // Start loading
//                    let newUser = User(
//                        id: nil,
//                        first_name: firstName,
//                        last_name: lastName,
//                        age: age ?? 0,  // Use optional binding
//                        male: male,
//                        address: address,
//                        birthday: Int(birthday.timeIntervalSince1970)
//                    )
//
//                    do {
//                        try await viewModel.addUser(newUser)
//                        isLoading = false  // Stop loading on success
//                        // Dismiss the view to return to the List User screen
//                        presentationMode.wrappedValue.dismiss()
//                    } catch {
//                        isLoading = false  // Stop loading on error
//                        // If adding fails, show an error alert
//                        showError = true
//                    }
//                }
//            }
//            .disabled(isLoading)  // Disable the button while loading
//        }
//        .navigationTitle("Add User")
//        .alert(isPresented: $showError) {
//            Alert(title: Text("Error"),
//                  message: Text("Failed to add user"),
//                  dismissButton: .default(Text("OK")))
//        }
//    }
//}
//
