//
//  BarItem.swift
//  Moon Store
//
//  Created by Jose Luna on 1/12/25.
//

import Foundation

struct BarItem: Identifiable {
    let id: UUID = UUID()
    let name: String
    let value: Double
}

// TODO: - Remove Mock Data

extension BarItem {
    static var lastWeek: [BarItem] {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "es_ES")
        formatter.dateFormat = "EEEE"
        
        return stride(from: 6, through: 0, by: -1).compactMap { index in
            guard let date = Calendar.current.date(byAdding: .day, value: -index, to: Date()) else { return nil }
            return BarItem(
                name: formatter.string(from: date).capitalized,
                value: .randomValue
            )
        }
    }
    
    static var categories: [BarItem] {
        ProductCategory.allCases.map {
            BarItem(name: $0.title, value: .randomValue)
        }
    }
}

// TODO: - Remove this extension

extension Double {
    static var randomValue: Double {
        Double(Int.random(in: 1...100))
    }
}
