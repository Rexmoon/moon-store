//
//  SwiftDataProvider.swift
//  moon-store-mac-os
//
// Created by Jose Luna on 6/12/24.
//

import SwiftData

// MARK: - SwiftData Provider

final class SwiftDataProvider {
    static let shared = SwiftDataProvider()
    
    lazy var container: ModelContainer = {
        do {
            return try ModelContainer(for: schema)
        } catch {
            fatalError("Error creating the model container\nError description: \(error.localizedDescription)")
        }
    }()
    
    lazy var context: ModelContext = {
        ModelContext(container)
    }()
    
    private let schema = Schema([UserModel.self,
                                 RoleModel.self])
    
    private init() { }
}
