//
//  BackupViewModel.swift
//  moon-store-mac-os
//
//  Created by Jose Luna on 1/5/25.
//

import Foundation

final class BackupViewModel: ObservableObject {
    @Published var backupList: [String] = []
    @Published var isLoading: Bool = false
    
    var shouldShowEmptyView: Bool {
        backupList.isEmpty && !isLoading
    }
    
    private let backupManager: BackupManager = .init()
    
    init() {
        getBackupList()
    }
    
    func getBackupList() {
        isLoading = true
        
        Task { @MainActor in
            defer { isLoading = false }
            
            do {
                backupList = try await backupManager.getBackupList()
            } catch {
                AlertPresenter.showAlert(with: error)
            }
        }
    }
    
    func showBackupConfirmationAlert() {
        AlertPresenter.showConfirmationAlert(
            message: "Esta seguro que desea realizar un backup de la base de datos?",
            actionButtonTitle: "Backup",
            action: #selector(backupDatabase)
        )
    }
    
    func restoreBackup(_ backup: String) {
        isLoading = true
        
        Task { @MainActor in
            defer { isLoading = false }
            
            do {
                try await backupManager.restoreBackup(with: backup)
                AlertPresenter.showAlert("Restauración realizada correctamente!")
                getBackupList()
            } catch {
                AlertPresenter.showAlert(with: error)
            }
        }
    }
    
    @objc
    private func backupDatabase() {
        isLoading = true
        
        Task { @MainActor in
            defer { isLoading = false }
            
            do {
                try await backupManager.backupDatabase()
                AlertPresenter.showAlert("Backup realizado correctamente!")
                getBackupList()
            } catch {
                AlertPresenter.showAlert(with: error)
            }
        }
    }
}
