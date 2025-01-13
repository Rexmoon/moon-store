//
//  MSTextField.swift
//  moon-store-mac-os
//
// Created by Jose Luna on 18/11/24.
//

import SwiftUI

private enum Constants {
    static let height: CGFloat = 40
    static let cornerRadius: CGFloat = 6
    static let lineWidth: CGFloat = 0.5
    static let eyeIcon: String = "eye"
    static let eyeSlashIcon: String = "eye.slash"
}

struct MSTextField: View {
    @Binding private var text: String
    @State private var isShowingText: Bool = false
    
    private let title: String
    private let placeholder: String
    private let isSecure: Bool
    private let axis: Axis
    private let height: CGFloat
    
    init(title: String,
         placeholder: String = "",
         text: Binding<String>,
         isSecure: Bool = false,
         axis: Axis = .horizontal,
         height: CGFloat = Constants.height) {
        _text = text
        self.title = title
        self.placeholder = placeholder
        self.isSecure = isSecure
        self.axis = axis
        self.height = height
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(title)
            
            textField
                .textFieldStyle(.plain)
                .frame(height: height)
                .overlay(alignment: .trailing) {
                    if isSecure { eyeButton }
                }
                .padding(.horizontal)
                .background {
                    RoundedRectangle(cornerRadius: Constants.cornerRadius)
                        .stroke(.gray, lineWidth: Constants.lineWidth)
                }
        }
    }
    
    // MARK: - Components
    
    @ViewBuilder
    private var textField: some View {
        if isSecure, !isShowingText {
            SecureField(placeholder, text: $text)
        } else {
            TextField(placeholder, text: $text, axis: axis)
        }
    }
    
    private var eyeButton: some View {
        Button {
            isShowingText.toggle()
        } label: {
            Image(
                systemName: isShowingText
                ? Constants.eyeIcon
                : Constants.eyeSlashIcon
            ).foregroundStyle(.gray)
        }
        .buttonStyle(.plain)
    }
}
