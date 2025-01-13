//
//  SwiftDataManager.swift
//  moon-store-mac-os
//
// Created by Jose Luna on 6/12/24.
//

import Foundation
import SwiftData

// MARK: - SwiftData Manager

final class DataManager<Model: PersistentModel> {
    private lazy var context: ModelContext = {
        SwiftDataProvider.shared.context
    }()
    
    // MARK: - Methods

    func save(model: Model) throws {
        context.insert(model)
        do {
            try context.save()
        } catch {
            throw MSError.notSaved
        }
    }
    
    func fetch(predicate: Predicate<Model> = .true) throws -> [Model] {
        do {
            let descriptor = FetchDescriptor(predicate: predicate)
            return try context.fetch(descriptor)
        } catch {
            throw MSError.notFound
        }
    }
    
    func removeAll() throws {
        do {
            try context.delete(model: Model.self)
        } catch {
            throw MSError.notDeleted
        }
    }
    
    func remove(model: Model) {
        context.delete(model)
    }
}
