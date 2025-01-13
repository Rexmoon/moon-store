//
//  ReportSection.swift
//  Moon Store
//
//  Created by Jose Luna on 1/12/25.
//

import Foundation

enum ReportSection: CaseIterable, Identifiable {
    case generalInventory
    case availableProducts
    case outOfStockProducts
    case bestSellingCategories
    case sales
    case weeklyProductSales
    case monthlyProductSales
    case users
    
    var id: String { String(describing: self) }
    
    var title: String {
        switch self {
            case .generalInventory: "Inventario general"
            case .availableProducts: "Productos disponibles"
            case .outOfStockProducts: "Productos agotados"
            case .bestSellingCategories: "Top categorías de ventas"
            case .weeklyProductSales: "Ventas de la última semana"
            case .monthlyProductSales: "Ventas del último mes"
            case .users: "Gestión de usuarios"
            case .sales: "Reporte de ventas"
        }
    }
}
