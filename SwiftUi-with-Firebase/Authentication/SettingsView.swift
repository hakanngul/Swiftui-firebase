//
//  SettingsView.swift
//  SwiftUi-with-Firebase
//
//  Created by Hakan Gül on 18.03.2023.
//

import SwiftUI

@MainActor
final class SettingsViewModel : ObservableObject {
    
    @Published var authProviders : [AuthProviderOption] = []
    
    func loadAuthProviders() {
        if let providers = try? AuthenticationManager.shared.getProvider() {
            authProviders = providers
        }
    }
    
    
    func signOut() throws {
        try AuthenticationManager.shared.signOut()
    }
    
    func getUser() async throws -> AuthDataResultModel {
        let authUser = try AuthenticationManager.shared.getAuthenticatedUser()
        guard authUser.email != nil else {
            throw URLError(.badServerResponse)
        }
        
        return authUser
    }
    
    
    func ressetPassword() async throws {
        let authUser = try AuthenticationManager.shared.getAuthenticatedUser()
        guard let email = authUser.email else {
            throw URLError(.fileDoesNotExist)
        }
        try await AuthenticationManager.shared.ressetPassword(email: email)
    }
    
    func updateEmail() async throws {
        let email = "deneme@gmail.com"
        try await AuthenticationManager.shared.updateEmail(email: email)
    }
    
    func updatePassword() async throws {
        let password = "123123x"
        try await AuthenticationManager.shared.updatePassword(password: password)
    }
}


struct SettingsView: View {
    @StateObject private var viewModel = SettingsViewModel()
    @Binding var showSignInView : Bool
    var body: some View {
        List {
            Button("Log Out") {
                Task {
                    do {
                        try viewModel.signOut()
                        showSignInView = true
                    } catch {
                        print(error)
                    }
                }
            }
            if viewModel.authProviders.contains(.email) {
                emailSection
            }
            
            
        }
        .onAppear {
            viewModel.loadAuthProviders()
        }
        .navigationTitle("Settings")
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            SettingsView(showSignInView: .constant(false))
        }
    }
}

extension SettingsView {
    private var emailSection: some View {
        Section {
            Button("Resset Password") {
                Task {
                    do {
                        try await viewModel.ressetPassword()
                        print("Password Reset!")
                        try viewModel.signOut()
                        showSignInView = true
                    } catch {
                        print(error)
                    }
                }
            }
            
            Button("Update Password") {
                Task {
                    do {
                        try await viewModel.updatePassword()
                        print("Update Password!")
                        try viewModel.signOut()
                        showSignInView = true
                    } catch {
                        print(error)
                    }
                }
            }
            
            Button("Update Email") {
                Task {
                    do {
                        try await viewModel.updateEmail()
                        print("Update Email!")
                        try viewModel.signOut()
                        showSignInView = true
                        
                    } catch {
                        print(error)
                    }
                }
            }
        } header: {
            Text("Email And Passwords Functions")
        }
    }
}
