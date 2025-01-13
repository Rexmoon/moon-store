//
//  BackupDatabaseManager.swift
//  moon-store-mac-os
//
//  Created by Jose Luna on 1/5/25.
//

import Foundation

final class BackupManager {
    private let networkManager: NetworkManager = .init()
    private let decoder: JSONDecoder = .init()
    
    // MARK: - Get backups
    
    func getBackupList() async throws -> [String] {
        do {
            let data = try await networkManager.getData(for: .listDatabase)
            let response = try decoder.decode(BackupListResponseModel.self, from: data)
            return response.data
        } catch {
            throw error
        }
    }
    
    // MARK: - Backup
    
    func backupDatabase() async throws {
        do {
            try await networkManager.postData(for: .backupDatabase)
        } catch {
            throw error
        }
    }
    
    // MARK: - Restore
    
    func restoreBackup(with backupName: String) async throws {
        let parameters: [String: Any] = [
            "backupName": backupName
        ]
        
        do {
            try await networkManager.postData(for: .restoreDatabase, with: parameters)
        } catch {
            throw error
        }
    }
}
