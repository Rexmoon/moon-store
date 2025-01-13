//
//  ProductModel.swift
//  moon-store-mac-os
//
//  Created by Jose Luna on 12/23/24.
//

import SwiftUI

enum ProductCategory: String, Decodable, CaseIterable, Identifiable {
    case laptop
    case phone
    case audio
    case pc
    case printer
    case battery
    case wearable
    case home
    case peripheral
    case networking
    
    var id: String { rawValue }
    
    var title: String {
        switch self {
        case .laptop: "Portatil"
        case .phone: "Telefono"
        case .audio: "Audio"
        case .pc: "PC"
        case .printer: "Impresora"
        case .battery: "Bateria"
        case .wearable: "Dispositivo portatil"
        case .home: "Hogar"
        case .peripheral: "Periferico"
        case .networking: "Redes"
        }
    }
    
    var color: Color {
        switch self {
            case .laptop, .phone, .pc: .msPrimary
            case .audio, .printer, .battery: .msOrange
            case .wearable, .home, .peripheral, .networking: .msGreen
            @unknown default: .msDarkGray
        }
    }
}

struct ProductModel: Decodable, Hashable, Identifiable {
    let id: Int
    let name: String
    let description: String
    let stock: Int
    let salePrice: Double
    let purchasePrice: Double
    let category: ProductCategory
    let images: [String]
    let createdAt: String
    let updatedAt: String
    let deletedAt: String?
}
