//
//  UserConstants.swift
//  moon-store-mac-os
//
// Created by Jose Luna on 30/12/24.
//

import SwiftUI

enum UserConstants {
    static let cornerRadius: CGFloat = 10
    static let iconSize: CGFloat = 30
    static let personIcon: String = "person.crop.circle.fill"
    static let padding: CGFloat = 6
    static let spacing: CGFloat = 15
    static let textFieldHeight: CGFloat = 40
    static let headerTableViewLeadingPadding: CGFloat = 25
    static let userFileName: String = "Usuarios"
    static let optionSize: CGFloat = 130
    
    enum Button {
        static let width: CGFloat = 125
        static let height: CGFloat = 35
    }
    
    enum UserRow {
        static let optionSize: CGFloat = 100
        static let spacing: CGFloat = 10
        static let trashIcon: String = "trash"
        static let reloadIcon: String = "arrow.trianglehead.2.clockwise.rotate.90"
        static let iconSize: CGFloat = 20
        static let height: CGFloat = 50
        static let lineLimit: Int = 1
        static let evenNumber: Int = 2
    }
}
