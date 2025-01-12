//
//  InvoiceListViewModel.swift
//  moon-store-mac-os
//
//  Created by Jose Luna on 1/8/25.
//

import Foundation

private enum Constants {
    static let invalidDate: String = "Fecha inválida"
}

final class InvoiceListViewModel: ObservableObject {
    @Published var invoiceList: [InvoiceModel] = []
    @Published var invoicePreviewList: [InvoiceSaleModel] = []
    @Published var isLoading: Bool = false
    @Published var selectedSale: InvoiceSaleModel?
    @Published var invoiceCount: Int = 0
    
    var cannotExportInvoice: Bool {
        invoiceList.isEmpty
    }
    
    var shouldShowEmptyView: Bool {
        invoiceList.isEmpty &&
        !isLoading
    }
    
    var canShowCounter: Bool {
        invoiceList.isNotEmpty &&
        !isLoading
    }
    
    private let invoiceManager: InvoiceManager = .init()
    
    init() {
        getInvoices()
    }
    
    func getInvoices() {
        isLoading = true
        invoiceList = []
        Task { @MainActor in
            defer { isLoading = false }
            
            do {
                invoiceList = try await invoiceManager.getInvoices()
                mapInvoicePreview()
                getInvoiceCount()
            } catch {
                AlertPresenter.showAlert(with: error)
            }
        }
    }
    
    func mapInvoicePreview() {
        invoicePreviewList = invoiceList.map { invoice in
            let products = invoice.details.map { detail in
                InvoiceSaleRowModel(
                    id: detail.id.description,
                    name: detail.productName,
                    quantity: detail.productQuantity.description,
                    price: "\(detail.productPrice)"
                )
            }
            
            return InvoiceSaleModel(
                id: invoice.id,
                clientName: invoice.customerName,
                clientIdentification: invoice.customerIdentification,
                createAt: invoice.createdAt.formattedDate ?? Constants.invalidDate,
                products: products
            )
        }
    }
    
    func updateInvoiceSelected(with id: Int) {
        guard let invoice = invoicePreviewList.first(where: { $0.id == id })
        else { return }
        selectedSale = invoice
    }
    
    private func getInvoiceCount() {
        isLoading = true
        
        Task { @MainActor in
            defer { isLoading = false }
            
            do {
                invoiceCount = try await invoiceManager.getInvoiceCount()
            } catch {
                AlertPresenter.showAlert(with: error)
            }
        }
    }
}
