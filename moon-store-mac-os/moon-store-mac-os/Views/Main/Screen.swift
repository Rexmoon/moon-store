//
//  Screen.swift
//  moon-store-mac-os
//
//  Created by Steven Santeliz on 17/11/24.
//

enum ScreenSection: String, Identifiable, CaseIterable {
    case overview = "Vista General"
    case inventory = "Inventario"
    case billing = "Facturación"
    
    var id: String { rawValue }
    
    var screens: [Screen] {
        switch self {
            case .overview: [.charts, .users, .backups]
            case .inventory: [.products]
            case .billing: [.createInvoice, .invoices]
        }
    }
    
    static func allCases(for roleId: Int) -> [ScreenSection] {
        guard let role = Role(rawValue: roleId) else { return [] }
        
        return switch role {
            case .owner, .admin: ScreenSection.allCases
            case .seller: [.billing]
            case .supplier: [.inventory]
        }
    }
}

enum Screen: String, Identifiable {
    case charts = "Gráficas"
    case users = "Usuarios"
    case products = "Lista de Productos"
    case createInvoice = "Creando Factura"
    case profile = "Perfil"
    case backups = "Backups"
    case invoices = "Historial de ventas"
    
    var id: String { rawValue }
    
    var iconName: String {
        switch self {
            case .charts: "square.grid.2x2"
            case .users, .profile: "person"
            case .products: "list.bullet.clipboard"
            case .createInvoice: "plus.circle"
            case .backups: "externaldrive.badge.icloud"
            case .invoices: "paperplane"
        }
    }
}

enum Role: Int, CaseIterable, Identifiable {
    case owner, admin, seller, supplier
    
    var id: Int { rawValue }
    
    var name: String {
        switch self {
            case .owner: "owner"
            case .admin: "admin"
            case .seller: "seller"
            case .supplier: "supplier"
        }
    }
    
    var title: String {
        switch self {
            case .owner: "Owner"
            case .admin: "Administrador"
            case .seller: "Vendedor"
            case .supplier: "Abastecedor"
        }
    }
    
    var differentRoles: [Role] {
        Role.allCases.filter { $0 != self }
    }
    
    static func getFromId(_ roleId: Int?) -> Role {
        guard let roleId,
              let role = Role(rawValue: roleId)
        else { return .supplier }
        return role
    }
}
