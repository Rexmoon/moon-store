//
//  View+ScreenSize.swift
//  moon-store-mac-os
//
// Created by Jose Luna on 17/11/24.
//

import SwiftUI

private enum Constants {
    static let minWidth: CGFloat = 700
    static let minHeight: CGFloat = 600
}

extension View {
    func screenSize() -> some View {
        frame(
            minWidth: Constants.minWidth,
            minHeight: Constants.minHeight
        )
        .frame(
            maxWidth: .infinity,
            maxHeight: .infinity
        )
    }
}
