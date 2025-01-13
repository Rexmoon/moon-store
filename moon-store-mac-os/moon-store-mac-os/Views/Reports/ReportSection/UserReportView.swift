//
//  UserReportView.swift
//  Moon Store
//
//  Created by Jose Luna on 1/12/25.
//

import SwiftUI

struct UserReportView: View {
    private let users: [UserModel]
    
    init(users: [UserModel]) {
        self.users = users
    }
    
    var body: some View {
        VStack(alignment: .trailing) {
            VStack(spacing: 5) {
                Grid { getGridRow() }
                
                MSDivider()
                
                userList
            }
            .padding()
            .background {
                RoundedRectangle(cornerRadius: 10)
                    .fill(.msWhite)
            }
            
            footerView
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .trailing)
    }
    
    
    private var userList: some View {
        ScrollView(showsIndicators: false) {
            Grid {
                ForEach(users) { user in
                    getGridRow(
                        name: "\(user.firstName) \(user.lastName)",
                        identification: user.identification,
                        email: user.email,
                        rol: user.roles.first?.name ?? "",
                        state: user.deletedAt == nil ? "Activo" : "Suspendido",
                        isHeader: false
                    )
                    
                    MSDivider()
                }
            }
        }
    }
    
    private func getGridRow(
        name: String = "Nombre",
        identification: String = "Identificación",
        email: String = "Email",
        rol: String = "Rol",
        state: String = "Estado",
        isHeader: Bool = true
    ) -> some View {
        GridRow {
            Group {
                Text(name)
                Text(identification)
                Text(email)
                Text(rol)
                Text(state)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .fontWeight(isHeader ? .bold : .regular)
    }
    
    private func totalItem(title: String, count: Int) -> some View {
        HStack {
            Text(title).bold()
            Text(count.description)
        }
        .padding(.horizontal)
        .frame(height: 30)
        .background {
            RoundedRectangle(cornerRadius: 10)
                .fill(.msGray)
        }
    }
    
    private var footerView: some View {
        HStack {
            totalItem(
                title: "Total de usuarios:",
                count: users.count
            )
            
            totalItem(
                title: "Activos:",
                count: users.map { $0.deletedAt == nil }.count
            )
            
            totalItem(
                title: "Desactivados:",
                count: users.map { $0.deletedAt != nil }.count
            )
        }
    }
}
