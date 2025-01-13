//
//  UserListView.swift
//  moon-store-mac-os
//
//  Created by Diana Zeledon on 23/12/24.
//

import SwiftUI

struct UserListView: View {
    @StateObject private var viewModel: UserListViewModel = .init()
    @State private var showInviteUserModal: Bool = false
    @State private var showRegisterUserModal: Bool = false
    
    var body: some View {
        VStack(spacing: UserConstants.spacing) {
            headerView
            
            productTableView
        }
        .frame(maxWidth: .infinity, alignment: .top)
        .padding()
        .showSpinner($viewModel.isLoading)
        .sheet(isPresented: $showInviteUserModal) {
            InviteUserView()
        }
        .sheet(isPresented: $showRegisterUserModal) {
            RegisterUserView { _ in
                viewModel.getUsers()
            }
        }
    }
    
    // MARK: - Header View
    
    private var headerView: some View {
        HStack {
            PrimaryButton(localizedString(.inviteUser)) {
                showInviteUserModal.toggle()
            }
            .frame(width: UserConstants.Button.width,
                   height: UserConstants.Button.height)
            
            PrimaryButton(localizedString(.registerButton)) {
                showRegisterUserModal.toggle()
            }
            .frame(width: UserConstants.Button.width,
                   height: UserConstants.Button.height)
            
            ExcelExporterButton(
                title: localizedString(.exportButton),
                fileName: UserConstants.userFileName,
                collection: viewModel.userList
            )
            .disabled(viewModel.cannotExportList)
        }
        .frame(maxWidth: .infinity, alignment: .trailing)
    }
    
    // MARK: - Table View
    
    private var productTableView: some View {
        VStack(spacing: .zero) {
            headerTableView
                .background(.msWhite)
            
            ScrollView(showsIndicators: false) {
                Grid(horizontalSpacing: .zero, verticalSpacing: .zero) {
                    ForEach(Array(viewModel.userList.enumerated()), id: \.element.id) { index, user in
                        userRowView(user: user, isEvenRow: index.isMultiple(of: UserConstants.UserRow.evenNumber))
                    }
                }
            }
            .fixedSize(horizontal: false, vertical: true)
        }
        .overlay {
            RoundedRectangle(cornerRadius: UserConstants.cornerRadius)
                .stroke(.msGray)
        }
        .clipShape(.rect(cornerRadius: UserConstants.cornerRadius))
        .frame(maxHeight: .infinity, alignment: .top)
    }
    
    // MARK: - Header Table View
    
    private var headerTableView: some View {
        Grid(horizontalSpacing: .zero, verticalSpacing: .zero) {
            GridRow {
                ForEach(UserTableHeader.allCases) { header in
                    Text(header.title)
                        .padding(header.padding)
                        .frame(maxWidth: .infinity,
                               alignment: header.alignment
                        )
                        .foregroundStyle(.msBlack)
                        .font(.body.bold())
                }
            }
            .frame(height: UserConstants.UserRow.height)
        }
    }
    
    // MARK: - Table Row View
    
    private func userRowView(user: UserModel, isEvenRow: Bool) -> some View {
        GridRow {
            HStack(spacing: UserConstants.UserRow.spacing) {
                let fullName: String = "\(user.firstName) \(user.lastName)"
                
                Text(fullName.abbreviated)
                    .frame(square: UserConstants.iconSize)
                    .background(.msPrimary, in: .circle)
                    .foregroundStyle(.msWhite)
                
                Text(fullName)
                    .leadingInfinity()
                    .foregroundStyle(.msBlack)
                    .lineLimit(UserConstants.UserRow.lineLimit)
            }
            .padding(.leading)
            .frame(maxWidth: .infinity)
            
            Group {
                Text(user.email)
                    .lineLimit(UserConstants.UserRow.lineLimit)
                    .leadingInfinity()
                
                Text(localizedString(.dateText(user.createdAt)))
                    .frame(alignment: .leading)
                
                optionsView(for: user)
            }
            .frame(maxWidth: .infinity)
            .foregroundStyle(.msDarkGray)
        }
        .frame(height: UserConstants.UserRow.height)
        .background(isEvenRow ? .msLightGray : .msWhite)
    }
    
    // MARK: - User options view
    
    @ViewBuilder
    private func optionsView(for user: UserModel) -> some View {
        let currentRole = Role.getFromId(user.roles.first?.id)
        
        HStack(spacing: UserConstants.UserRow.spacing) {
            Menu(currentRole.title) {
                ForEach(currentRole.differentRoles) { role in
                    Button(role.title) {
                        viewModel.assignRole(
                            role: role.name,
                            email: user.email,
                            revoke: currentRole.id
                        )
                    }
                }
            }
            .menuStyle(.borderedButton)
            .frame(width: UserConstants.optionSize)
            
            Button {
                user.deletedAt == nil
                ? viewModel.showDisableUserConfirmationAlert(for: user.id)
                : viewModel.showEnableUserConfirmationAlert(for: user.id)
            } label: {
                Image(systemName: user.deletedAt == nil
                      ? UserConstants.UserRow.trashIcon
                      : UserConstants.UserRow.reloadIcon)
                    .resizable()
                    .frame(square: UserConstants.UserRow.iconSize)
                    .foregroundStyle(.red)
            }
            .buttonStyle(.plain)
        }
        .disabled(currentRole == .owner)
    }
}

extension UserListView {
    private enum TitleValue {
        case header, inviteUser, edit, registerButton, exportButton, dateText(String?)
    }
    
    private func localizedString(_ key: TitleValue) -> String {
        switch key {
            case .header: "Vista General"
            case .inviteUser: "Invitar usuarios"
            case .edit: "Editar Roles"
            case .registerButton: "Registrar usuario"
            case .exportButton: "Exportar"
            case .dateText(let date): date?.formattedDate ?? "Fecha inválida"
        }
    }
}

#Preview {
    UserListView()
}
