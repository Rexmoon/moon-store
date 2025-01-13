//
//  CreateInvoiceViewModel.swift
//  moon-store-mac-os
//
//  Created by Jose Luna on 1/11/25.
//

import Foundation

private enum Constants {
    static let minRowCount: Int = 2
    static let maxRowCount: Int = 10
}

final class CreateInvoiceViewModel: ObservableObject {
    @Published var invoice: InvoiceSaleModel = .init()
    @Published var products: [ProductModel] = []
    @Published var isLoading: Bool = false
    
    var cannotRemoveInvoiceRow: Bool {
        invoice.products.count < Constants.minRowCount
    }
    
    var cannotAddInvoiceRow: Bool {
        invoice.products.count >= Constants.maxRowCount
    }
    
    var cannotCreateInvoice: Bool {
        products.isEmpty ||
        !invoice.products.allSatisfy { $0.selectedProduct != nil } ||
        invoice.clientName.isEmpty ||
        invoice.clientIdentification.isEmpty
    }
    
    private let invoiceManager: InvoiceManager = .init()
    private let productManager: ProductManager = .init()
    
    init() {
        getProducts()
    }
    
    func addInvoiceRow() {
        cannotAddInvoiceRow
        ? showMaxRowCountExceededAlert()
        : invoice.products.append(.init())
    }
    
    func removeInvoiceRow(at index: Int) {
        invoice.products.remove(at: index)
    }
    
    func createInvoice() {
        isLoading = true
        
        Task { @MainActor in
            defer { isLoading = false }
            
            do {
                try await invoiceManager.createInvoice(invoice: invoice)
                resetPropertiesToDefaultValue()
                getProducts()
                AlertPresenter.showAlert("Factura creada correctamente!")
            } catch {
                AlertPresenter.showAlert(with: error)
            }
        }
    }
    
    private func getProducts() {
        isLoading = true
        
        Task { @MainActor in
            defer { isLoading = false }
            
            do {
                let productsFetched = try await productManager.getProducts()
                products = productsFetched.filter { $0.stock > .zero }
            } catch {
                AlertPresenter.showAlert(with: error)
            }
        }
    }
    
    private func resetPropertiesToDefaultValue() {
        invoice = .init()
        products = []
    }
    
    private func showMaxRowCountExceededAlert() {
        AlertPresenter.showAlert(
            "No se pueden agregar más de \(Constants.maxRowCount) productos por factura."
        )
    }
}
