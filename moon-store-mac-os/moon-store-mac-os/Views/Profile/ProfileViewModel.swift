//
//  UserViewModel.swift
//  moon-store-mac-os
//
//  Created by Jose Luna on 1/5/25.
//

import Foundation

@MainActor
final class ProfileViewModel: ObservableObject {
    @Published var currentPassword: String = ""
    @Published var newPassword: String = ""
    @Published var confirmPassword: String = ""
    @Published var isLoading: Bool = false
    
    var cannotUpdatePassword: Bool {
        currentPassword.isEmpty ||
        newPassword.isEmpty ||
        confirmPassword.isEmpty
    }
    
    private let userManager: UserManager = .init()
    
    func updatePassword(with email: String) {
        guard !cannotUpdatePassword else { return }
        
        isLoading = true
        
        Task { 
            defer { isLoading = false }
            do {
                try await userManager.updatePassword(email: email,
                                                     currentPassword: currentPassword,
                                                     newPassword: newPassword,
                                                     confirmPassword: confirmPassword)
                AlertPresenter.showAlert("Contraseña actualizada correctamente!")
                resetTextFields()
            } catch {
                AlertPresenter.showAlert(with: error)
            }
        }
    }
    
    private func resetTextFields() {
        currentPassword = ""
        newPassword = ""
        confirmPassword = ""
    }
}
