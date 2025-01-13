//
//  BackupView.swift
//  moon-store-mac-os
//
//  Created by Jose Luna on 1/5/25.
//

import SwiftUI

private enum Constants {
    static let lineLimit: Int = 1
    static let cornerRadius: CGFloat = 8
    static let buttonWidth: CGFloat = 200
    static let restoreButtonWidth: CGFloat = 100
    static let restoreButtonHeight: CGFloat = 20
}

struct BackupView: View {
    @StateObject private var viewModel: BackupViewModel = .init()
    
    var body: some View {
        VStack {
            PrimaryButton(localizedString(.addBackupButton)) {
                viewModel.showBackupConfirmationAlert()
            }
            .frame(width: Constants.buttonWidth)
            .frame(maxWidth: .infinity, alignment: .trailing)
            
            if viewModel.backupList.isNotEmpty {
                ScrollView {
                    ForEach(viewModel.backupList, id: \.self) { backup in
                        HStack {
                            Text("\(localizedString(.rowPrefix)) \(backup)")
                                .lineLimit(Constants.lineLimit)
                            
                            PrimaryButton(localizedString(.restoreButton)) {
                                viewModel.restoreBackup(backup)
                            }
                            .frame(width: Constants.buttonWidth, height: Constants.restoreButtonHeight)
                            .frame(maxWidth: .infinity, alignment: .trailing)
                        }
                        .padding()
                    }
                }
                .background(.msWhite, in: .rect(cornerRadius: Constants.cornerRadius))
                .fixedSize(horizontal: false, vertical: true)
            }
        }
        .frame(maxHeight: .infinity, alignment: .top)
        .padding()
        .background {
            if viewModel.shouldShowEmptyView {
                MSEmptyListView {
                    viewModel.getBackupList()
                }
            }
        }
        .showSpinner($viewModel.isLoading)
    }
}

// MARK: Localized

extension BackupView {
    private enum BackupViewKey {
        case headerTitle
        case addBackupButton
        case rowPrefix
        case restoreButton
    }
    
    private func localizedString(_ key: BackupViewKey) -> String {
        switch key {
            case .headerTitle: "Respaldo"
            case .addBackupButton: "Respaldar base de datos"
            case .rowPrefix: "Nombre del respaldo: "
            case .restoreButton: "Restaurar"
        }
    }
}

#Preview {
    BackupView()
}
