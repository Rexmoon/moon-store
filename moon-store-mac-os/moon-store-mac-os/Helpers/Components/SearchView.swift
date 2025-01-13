//
//  SearchView.swift
//  moon-store-mac-os
//
// Created by Jose Luna on 11/12/24.
//

import SwiftUI

private enum Constants {
    static let searchTextFieldHeight: CGFloat = 40
    static let cornerRadius: CGFloat = 10
    static let padding: CGFloat = 5
    static let searchWidth: CGFloat = 300
    static let cancelTitle: String = "Cancelar"
    static let placeholderText: String = "Buscar..."
    static let searchIcon: String = "magnifyingglass"
    static let clearIcon: String = "xmark.circle.fill"
}

struct SearchView: View {
    @Binding private var searchText: String
    @FocusState private var isSearchFocused: Bool
 
    init(searchText: Binding<String>) {
        _searchText = searchText
    }

    var body: some View {
        HStack {
            HStack {
                Image(systemName: Constants.searchIcon)
                    .foregroundStyle(Color(.msGray))
                    .padding(.leading, Constants.padding)
                    .accessibilityHidden(true)

                TextField(Constants.placeholderText, text: $searchText)
                    .focused($isSearchFocused)
                    .foregroundStyle(Color(.black))
                    .textFieldStyle(.plain)
            }
            .frame(height: Constants.searchTextFieldHeight)
            .background(.msWhite)
            .clipShape(RoundedRectangle(cornerRadius: Constants.cornerRadius))
            .overlay(alignment: .trailing) {
                if isSearchFocused, !searchText.isEmpty {
                    clearButton
                }
            }

            if isSearchFocused {
                cancelButton
            }
        }
        .frame(width: Constants.searchWidth)
    }

    // MARK: - Clear Button

    private var clearButton: some View {
        Button {
            withAnimation(.smooth) {
                searchText = ""
            }
        } label: {
            Image(systemName: Constants.clearIcon)
                .padding(.trailing, Constants.padding)
                .foregroundStyle(Color(.msGray))
        }
    }

    // MARK: - Cancel Button

    private var cancelButton: some View {
        Button(Constants.cancelTitle) {
            withAnimation(.smooth) {
                searchText = ""
                isSearchFocused = false
            }
        }
    }
}
