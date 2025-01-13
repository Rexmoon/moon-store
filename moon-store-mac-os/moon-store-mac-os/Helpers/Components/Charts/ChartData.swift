//
//  ChartData.swift
//  moon-store-mac-os
//
// Created by Jose Luna on 10/1/25.
//

import Foundation

struct ChartData: Identifiable {
    let id: String = UUID().uuidString
    let name: String
    let value: Double
}
