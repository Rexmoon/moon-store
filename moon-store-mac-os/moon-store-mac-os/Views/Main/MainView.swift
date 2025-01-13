//
//  MainView.swift
//  moon-store-mac-os
//
// Created by Jose Luna on 11/16/24.
//

import SwiftUI

private enum Constants {
    static let profileButtonSize: CGFloat = 25
}

struct MainView: View {
    @EnvironmentObject private var router: AppRouter
    @State private var screenSelection: Screen = .profile
    @State private var subNavigation: String?
    
    private let user: UserModel
    
    init(user: UserModel) {
        self.user = user
    }
    
    var body: some View {
        NavigationSplitView {
            Sidebar(
                screenSelection: $screenSelection,
                roleId: user.roles.first?.id ?? .zero
            )
        } detail: {
            detailContent
                .screenSize()
                .background(.msLightGray)
                .navigationTitle(screenSelection.id)
        }
        .toolbarBackground(.hidden)
        .navigationBarBackButtonHidden()
        .toolbar {
            ToolbarItem(placement: .confirmationAction) {
                profileButton
            }
        }
    }
    
    @ViewBuilder
    private var detailContent: some View {
        switch screenSelection {
            case .products: ProductListView()
            case .users: UserListView()
            case .profile: ProfileView(user: user)
            case .charts: GraphicsView()
            case .backups: BackupView()
            case .invoices: InvoiceListView()
            case .createInvoice: CreateInvoiceView()
            case .salesReport: ReportView(subNavigation: $subNavigation)
            @unknown default: Text(screenSelection.rawValue)
        }
    }
    
    private var profileButton: some View {
        Button("\(user.firstName) \(user.lastName)".abbreviated) {
            screenSelection = .profile
        }
        .buttonStyle(.plain)
        .bold()
        .frame(square: Constants.profileButtonSize)
        .background(.msPrimary, in: .circle)
        .foregroundStyle(.msWhite)
    }
}
