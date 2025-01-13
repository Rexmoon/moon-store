//
//  UserInviteView.swift
//  moon-store-mac-os
//
// Created by Jose Luna on 28/12/24.
//

import SwiftUI

private enum Constants {
    static let iconSize: CGFloat = 16
    static let iconTitle: String = "xmark"
    static let height: CGFloat = 120
    static let buttonWidth: CGFloat = 120
    static let verticalPadding: CGFloat = 5
    static let buttonTopPadding: CGFloat = 22
}

struct InviteUserView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var viewModel: InviteUserViewModel = .init()
    
    var body: some View {
        VStack(alignment: .trailing) {
            Button {
                dismiss()
            } label: {
                Image(systemName: Constants.iconTitle)
                    .resizable()
                    .frame(square: Constants.iconSize)
                    .foregroundStyle(.msPrimary)
            }
            .buttonStyle(.plain)
            .padding(.top, Constants.verticalPadding)
            
            HStack {
                MSTextField(title: localizedString(.emailTextFieldTitle),
                            text: $viewModel.email)
                
                PrimaryButton(localizedString(.inviteButtonTitle)) {
                    viewModel.showModalToInviteUser()
                    dismiss()
                }
                .frame(width: Constants.buttonWidth)
                .disabled(viewModel.cannotOpenMailApp)
                .padding(.top, Constants.buttonTopPadding)
            }
        }
        .frame(minHeight: Constants.height,
               alignment: .top)
        .padding(.horizontal)
    }
}

// MARK: - Localized

extension InviteUserView {
    private enum InviteUserViewKey {
        case emailTextFieldTitle, inviteButtonTitle
    }
    
    private func localizedString(_ key: InviteUserViewKey) -> String {
        switch key {
            case .emailTextFieldTitle: "Dirección de correo:"
            case .inviteButtonTitle: "Invitar"
        }
    }
}
