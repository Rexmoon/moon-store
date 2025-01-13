//
//  SpinnerModifier.swift
//  moon-store-mac-os
//
// Created by Jose Luna on 30/12/24.
//

import SwiftUI

struct SpinnerModifier: ViewModifier {
    @Binding private var showSpinner: Bool
    
    init(showSpinner: Binding<Bool>) {
        _showSpinner = showSpinner
    }
    
    func body(content: Content) -> some View {
        if showSpinner {
            content
                .overlay {
                    MSSpinner()
                }
        } else {
            content
        }
    }
}
