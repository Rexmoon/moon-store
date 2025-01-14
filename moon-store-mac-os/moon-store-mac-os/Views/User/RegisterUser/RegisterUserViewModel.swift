//
//  RegisterUserViewModel.swift
//  moon-store-mac-os
//
//  Created by Jose Luna on 1/7/25.
//

import Foundation

@MainActor
final class RegisterUserViewModel: ObservableObject {
    @Published var userModel: UserRegisterModel = .init()
    @Published var isLoading: Bool = false
    @Published var userRegistered: UserModel?
    
    var cannotRegisterYet: Bool {
        userModel.cannotRegisterYet ||
        userModel.password != userModel.confirmPassword
    }
    
    private let userManager: UserManager = .init()
    
    func registerUser() {
        isLoading = true
        
        Task { 
            defer { isLoading = false }
            
            do {
                let user = try await userManager.registerUser(user: userModel)
                AlertPresenter.showAlert("Usuario registrado exitosamente!")
                userModel = UserRegisterModel()
                userRegistered = user
            } catch {
                AlertPresenter.showAlert(with: error)
            }
        }
    }
}
