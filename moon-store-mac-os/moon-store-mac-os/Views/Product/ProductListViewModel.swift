//
//  ProductListViewModel.swift
//  moon-store-mac-os
//
//  Created by Jose Luna on 12/24/24.
//

import Foundation

final class ProductListViewModel: ObservableObject {
    @Published var isLoading: Bool = false
    @Published var productList: [ProductModel] = []
    
    @Published var searchText: String = "" {
        didSet { searchTextDidChange() }
    }
    
    private let productRepository: ProductRepository
    
    private var isSearchInProgress: Bool = false
    private var products: [ProductModel] = []
    private var productsFiltered: [ProductModel] = []
    
    init(productRepository: ProductRepository = .init()) {
        self.productRepository = productRepository
        getProducts()
    }
    
    func getProducts() {
        resetValues()
        
        isLoading = true
        
        Task { @MainActor in
            defer { isLoading = false }
            
            do {
                products = try await productRepository.getProducts()
                productList = products
            } catch let error as MSError {
                AlertPresenter().showAlert(type: .error,
                                           alertMessage: error.friendlyMessage)
            }
        }
    }
    
    private func resetValues() {
        products = []
        productList = []
        productsFiltered = []
        searchText = ""
    }
    
    private func searchTextDidChange() {
        let searchText = searchText.trimmingCharacters(in: .whitespacesAndNewlines)
        isSearchInProgress = searchText != ""
        
        productsFiltered = products.filter { product in
            product.name.lowercased().contains(searchText.lowercased())
        }
        
        productList = isSearchInProgress
        ? productsFiltered
        : products
    }
}
