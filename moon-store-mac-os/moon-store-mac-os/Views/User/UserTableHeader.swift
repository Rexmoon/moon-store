//
//  UserTableHeader.swift
//  moon-store-mac-os
//
// Created by Jose Luna on 30/12/24.
//

import SwiftUI

enum UserTableHeader: CaseIterable, Identifiable {
    case user, email, date, role
    
    var id: UserTableHeader { self }
    
    var title: String {
        switch self {
            case .user: "Usuario"
            case .email: "Email"
            case .date: "Fecha"
            case .role: "Rol"
        }
    }
    
    var alignment: Alignment {
        switch self {
            case .role, .date: .center
            default: .leading
        }
    }
    
    var padding: Edge.Set {
        switch self {
            case .user: .leading
            default: .vertical
        }
    }
}
