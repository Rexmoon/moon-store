//
//  ProductListViewModel.swift
//  moon-store-mac-os
//
//  Created by Jose Luna on 12/24/24.
//

import Foundation

final class ProductListViewModel: ObservableObject {
    @Published var productList: [ProductModel] = []
    @Published var isLoading: Bool = false
    @Published var productCount: Int = .zero
    @Published var searchText: String = "" {
        didSet {
            filterProducts()
        }
    }
    
    var shouldShowEmptyView: Bool {
        productList.isEmpty &&
        !isLoading &&
        !isSearchInProgress
    }
    
    var cannotExportProducts: Bool {
        productList.isEmpty
    }
    
    var productSelected: ProductModel?
    
    private let productManager: ProductManager = .init()
    private let decoder: JSONDecoder = .init()
    
    private var isSearchInProgress: Bool = false
    private var products: [ProductModel] = []
    private var productsFiltered: [ProductModel] = []
    
    init () {
        getProducts()
    }
    
    func getProducts() {
        isLoading = true
        
        Task { @MainActor in
            defer { isLoading = false }
            
            do {
                products = try await productManager.getProducts()
                productList = products
                getProductCount()
            } catch {
                AlertPresenter.showAlert(with: error)
            }
        }
    }
    
    func showDeleteAlert(with id: Int) {
        updateSelectedProduct(with: id)
        
        AlertPresenter.showConfirmationAlert(
            message: "¿Está seguro que quiere eliminar el producto?",
            actionButtonTitle: "Eliminar",
            isDestructive: true,
            action: #selector(deleteSelectedProduct)
        )
    }
    
    func supplyProductSelectedProduct(_ quantity: String) {
        guard let productSelected,
              let quantity = Double(quantity) else { return }
        
        isLoading = true
        
        Task { @MainActor in
            defer {
                isLoading = false
            }
            
            do {
                try await productManager.supplyProduct(id: productSelected.id,
                                                       with: quantity)
                getProducts()
            } catch {
                AlertPresenter.showAlert(with: error)
            }
        }
    }
    
    func updateSelectedProduct(with id: Int) {
        productSelected = products.first { $0.id == id }
    }
    
    private func getProductCount() {
        Task { @MainActor in
            do {
                productCount = try await productManager.getProductCount()
            } catch {
                AlertPresenter.showAlert(with: error)
            }
        }
    }
    
    @objc
    private func deleteSelectedProduct() {
        guard let productSelected else { return }
        
        isLoading = true
        Task { @MainActor in
            defer {
                isLoading = false
            }
            
            do {
                try await productManager.deleteProduct(with: productSelected.id)
                getProducts()
            } catch {
                AlertPresenter.showAlert(with: error)
            }
        }
    }
    
    private func filterProducts() {
        isSearchInProgress = searchText != ""
        productsFiltered = products.filter { product in
            product.name.localizedCaseInsensitiveContains(searchText)
        }
        
        productList = isSearchInProgress
        ? productsFiltered
        : products
    }
}
