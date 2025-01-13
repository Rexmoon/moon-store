//
//  PrimaryButton.swift
//  moon-store-mac-os
//
// Created by Jose Luna on 18/11/24.
//

import SwiftUI

private enum Constants {
    static let maxHeight: CGFloat = 40
    static let cornerRadius: CGFloat = 6
}

struct PrimaryButton: View {
    private let title: String
    private let backgroundColor: Color
    private let action: () -> Void
    
    init(_ title: String,
         backgroundColor: Color = .msPrimary,
         action: @escaping () -> Void) {
        self.title = title
        self.backgroundColor = backgroundColor
        self.action = action
    }
    
    var body: some View {
        Button(title) {
            withAnimation { action() }
        }
        .buttonStyle(.plain)
        .frame(maxWidth: .infinity, maxHeight: Constants.maxHeight)
        .foregroundStyle(.msWhite)
        .background(backgroundColor,
                    in: .rect(cornerRadius: Constants.cornerRadius))
    }
}
