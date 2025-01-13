//
//  Information.swift
//  moon-store-mac-os
//
// Created by Jose Luna on 6/1/25.
//

import SwiftUI

struct CardGraphicModel: Identifiable {
    let id: UUID = .init()
    let title: String
    let count: Int
    let iconName: String
    let description: String
    let color: Color
}

enum CardGraphic {
    case products(Int)
    case invoices(Int)
    case users(Int)
    
    private var title: String {
        switch self {
            case .products: "Productos"
            case .invoices: "Facturas"
            case .users: "Usuarios"
        }
    }
    
    private var iconName: String {
        switch self {
            case .products: "cart.fill"
            case .invoices: "doc.text.fill"
            case .users: "person.2.fill"
        }
    }
    
    private var description: String {
        switch self {
            case .products: "Productos actualmente registrados en el inventario."
            case .invoices: "Facturas generadas y almacenadas en el sistema."
            case .users: "Usuarios actualmente registrados en el sistema."
        }
    }
    
    private var color: Color {
        switch self {
            case .products: .msPrimary
            case .invoices: .msGreen
            case .users: .msDarkBlue
        }
    }
    
    private var count: Int {
        switch self {
            case .products(let count): count
            case .invoices(let count): count
            case .users(let count): count
        }
    }
    
    var model: CardGraphicModel {
        CardGraphicModel(
            title: title,
            count: count,
            iconName: iconName,
            description: description,
            color: color
        )
    }
}
