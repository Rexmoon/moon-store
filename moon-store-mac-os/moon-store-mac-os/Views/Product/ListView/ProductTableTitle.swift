//
//  ProductTableTitle.swift
//  moon-store-mac-os
//
// Created by Jose Luna on 4/1/25.
//

import SwiftUI

enum ProductTableTitle: CaseIterable, Identifiable {
    case product
    case category
    case inStock
    case price
    case options
    
    var id: ProductTableTitle { self }

    var title: String {
        switch self {
            case .product: "Producto"
            case .category: "Categoría"
            case .inStock: "En Stock"
            case .price: "Precio"
            default: ""
        }
    }
    
    var width: CGFloat {
        switch self {
            case .product: .infinity
            case .category: ProductListConstants.ProductRow.categorySize
            case .inStock, .price: ProductListConstants.ProductRow.stockSize
            case .options: ProductListConstants.ProductRow.optionsSise
        }
    }
    
    var padding: Edge.Set {
        switch self {
            case .product: .leading
            case .options: .trailing
            default: .vertical
        }
    }
}
