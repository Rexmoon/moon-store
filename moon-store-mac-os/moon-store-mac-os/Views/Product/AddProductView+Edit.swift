//
//  AddProductView+Edit.swift
//  moon-store-mac-os
//
//  Created by Jose Luna on 1/2/25.
//

import SwiftUI
import PhotosUI

private enum Constants {
    static let cornerRadiusSize: CGFloat = 4
    static let createButtonWidth: CGFloat = 200
    static let crossIcon: String = "xmark"
    static let descriptionHeight: CGFloat = 90
    static let imageSpacing: CGFloat = 25
    static let modalMinHeight: CGFloat = 450
    static let modalMinWidth: CGFloat = 650
    static let categoryHeight: CGFloat = 30
    static let categoryPadding: CGFloat = 5
}

struct AddProductView: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject private var viewModel: AddProductViewModel = .init()
    
    private let onProductCreated: () -> Void
    
    init(onProductCreated: @escaping () -> Void) {
        self.onProductCreated = onProductCreated
    }
    
    var body: some View {
        VStack(alignment: .trailing) {
            modalHeader
            
            HStack(alignment: .top) {
                MSImagePickerView(selectedImage: $viewModel.imageSelected)
                    .padding(.top, Constants.imageSpacing)
                
                productInformationView
            }
            
            PrimaryButton(localizedString(.addProductButton)) {
                viewModel.addProduct()
            }
            .disabled(!viewModel.canCreateProduct)
            .frame(width: Constants.createButtonWidth)
            .padding(.top)
        }
        .padding()
        .frame(
            minWidth: Constants.modalMinWidth,
            minHeight: Constants.modalMinHeight,
            alignment: .top
        )
        .background(.msWhite)
        .showSpinner($viewModel.isLoading)
        .onReceive(viewModel.$wasCreatedSuccessfully) { success in
            guard success else { return }
            dismiss()
            onProductCreated()
        }
    }
    
    private var modalHeader: some View {
        HStack {
            Text(localizedString(.title))
                .font(.headline)
                .leadingInfinity()
            
            Button {
                dismiss()
            } label: {
                Image(systemName: Constants.crossIcon)
            }
        }
    }
    
    // MARK: - Product Information
    
    private var productInformationView: some View {
        VStack {
            MSTextField(
                title: localizedString(.productName),
                text: $viewModel.name
            )
            
            HStack {
                MSTextField(
                    title: localizedString(.productPrice),
                    text: $viewModel.price.allowOnlyDecimalNumbers
                )

                MSTextField(
                    title: localizedString(.productStock),
                    text: $viewModel.stock.allowOnlyNumbers
                )
            }
            
            MSTextField(
                title: localizedString(.productDescription),
                text: $viewModel.description,
                axis: .vertical,
                height: Constants.descriptionHeight
            )
            
            categoryButton
        }
    }
    
    // MARK: - Category Menu
    
    private var categoryButton: some View {
        VStack(alignment: .leading) {
            Text(localizedString(.productCategory))
            
            Menu(viewModel.category.title) {
                ForEach(ProductCategory.allCases) { category in
                    Button(category.title) {
                        viewModel.category = category
                    }
                }
            }
            .menuStyle(.borderlessButton)
            .frame(height: Constants.categoryHeight)
            .padding(.horizontal, Constants.categoryPadding)
            .overlay {
                RoundedRectangle(cornerRadius: Constants.cornerRadiusSize)
                    .stroke(.msGray)
            }
        }
    }
}

// MARK: Localized String

extension AddProductView {
    private enum AddProductViewKey {
        case addProductButton
        case title
        case productName
        case productDescription
        case productPrice
        case productStock
        case productCategory
    }
    
    private func localizedString(_ key: AddProductViewKey) -> String {
        switch key {
            case .addProductButton: "Agregar producto"
            case .title: "Agregando producto"
            case .productName: "Nombre"
            case .productDescription: "Descripción"
            case .productPrice: "Precio"
            case .productStock: "Unidades disponibles"
            case .productCategory: "Categoría"
        }
    }
}

#Preview {
    AddProductView() { }
}

