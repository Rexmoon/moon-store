//
//  LoginViewModel.swift
//  moon-store-mac-os
//
//  Created by Jose Luna on 12/15/24.
//

import Foundation

@MainActor
final class LoginViewModel: ObservableObject {
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var isLoading: Bool = false
    @Published var loggedUser: UserModel?
    
    private let authenticationManager: AuthenticationManager = .init()
    
    var cannotLoginYet: Bool {
        !email.matchesEmail ||
        password.isEmpty
    }
    
    init() {
        loggedUser = authenticationManager.loggedUser
    }
    
    func login() {
        isLoading = true
        
        Task { 
            defer { isLoading = false }
            
            do {
                let user = try await authenticationManager.login(email: email,
                                                      password: password)
                loggedUser = user
                resetPropertiesDefaultValue()
            } catch {
                AlertPresenter.showAlert(with: error)
            }
        }
    }
    
    func logout() {
        authenticationManager.logout()
    }
    
    private func resetPropertiesDefaultValue() {
        email = ""
        password = ""
        loggedUser = nil
    }
}
