//
//  AuthenticationManager.swift
//  moon-store-mac-os
//
//  Created by Jose Luna on 1/8/25.
//

import Foundation

@MainActor
final class AuthenticationManager {
    private let networkManager: NetworkManager = .init()
    private let decoder: JSONDecoder = .init()
    private let userStore: DataManager<UserModel> = .init()
    
    var isLoggedUser: Bool {
        loggedUser != nil
    }
    
    var loggedUser: UserModel? {
        let users = try? userStore.fetch()
        return users?.first
    }
    
    // MARK: - Login
    
    func login(email: String, password: String) async throws -> UserModel {
        let parameters: [String: Any] = [
            "email": email,
            "password": password
        ]
        
        do {
            let data = try await networkManager.postData(for: .login, with: parameters)
            let response = try decoder.decode(LoginResponseModel.self, from: data)
            let user = response.user
            try storeUser(user)
            return user
        } catch {
            throw error
        }
    }
    
    // MARK: - Logout
    
    func logout() {
        guard isLoggedUser else { return }
        
        do {
            try userStore.removeAll()
        } catch {
            AlertPresenter.showAlert(with: error)
        }
    }
    
    private func storeUser(_ user: UserModel) throws {
        do {
            try userStore.save(model: user)
        } catch {
            throw error
        }
    }
}
