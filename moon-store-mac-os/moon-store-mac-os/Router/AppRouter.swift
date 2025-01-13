//
//  AppRouter.swift
//  moon-store-mac-os
//
// Created by Jose Luna on 9/12/24.
//

import SwiftUI

final class AppRouter: ObservableObject {
    @Published var navigationPath: NavigationPath = .init()
    
    lazy var associatedView: some View = {
        build(for: .login)
    }()
    
    func push(_ path: AppTransition) {
        navigationPath.append(path)
    }
    
    func pop() {
        guard !navigationPath.isEmpty else { return }
        navigationPath.removeLast()
    }
    
    func popToRoot() {
        guard !navigationPath.isEmpty else { return }
        navigationPath.removeLast(navigationPath.count)
    }
    
    @ViewBuilder
    func build(for route: AppTransition) -> some View {
        switch route {
            case .login: LoginView()
            case .main(let user): MainView(user: user)
        }
    }
}
