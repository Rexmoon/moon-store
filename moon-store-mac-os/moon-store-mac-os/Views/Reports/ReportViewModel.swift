//
//  ReportViewModel.swift
//  Moon Store
//
//  Created by Jose Luna on 1/12/25.
//

import Foundation

@MainActor
final class ReportViewModel: ObservableObject {
    @Published var allProducts: [ProductModel] = []
    @Published var availableStock: [ProductModel] = []
    @Published var outOfStock: [ProductModel] = []
    @Published var users: [UserModel] = []
    @Published var users2: [String] = []
    @Published var invoices: [InvoiceModel] = []
    @Published var sevenDaysAgo: [InvoiceModel] = []
    @Published var oneMonthAgo: [InvoiceModel] = []
    @Published var bestSellingCategories: [BarItem] = []
    
    private let productManager: ProductManager = .init()
    private let invoiceManager: InvoiceManager = .init()
    private let authenticationManager: AuthenticationManager = .init()
    private let userManager: UserManager = .init()
    
    init() {
        loadData()
    }
    
    func loadData() {
        getProducts()
        getInvoices()
        getUsers()
    }
    
    private func getProducts() {
        Task { 
            do {
                let products = try await productManager.getProducts()
                allProducts = products
                availableStock = products.filter { $0.stock > .zero }
                outOfStock = products.filter { $0.stock <= .zero }
            } catch {
                AlertPresenter.showAlert(with: error)
            }
        }
    }
    
    private func getUsers() {
        Task { 
            do {
                let userList = try await userManager.getUsers()
                users = userList.sorted { $0.createdAt > $1.createdAt }
            } catch {
                AlertPresenter.showAlert(with: error)
            }
        }
    }
    
    private func getInvoices() {
        Task { 
            do {
                let sales = try await invoiceManager.getInvoices()
                invoices = sales.sorted { $0.createdAt > $1.createdAt }
                previousInvoices(sales)
                createBarItems(from: sales)
            } catch {
                AlertPresenter.showAlert(with: error)
            }
        }
    }
    
    private func previousInvoices(_ invoices: [InvoiceModel]) {
        let today = Date()
        
        let dateFormatter = ISO8601DateFormatter()
        dateFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        
        if let sevenDaysAgo = Calendar.current.date(byAdding: .day, value: -7, to: today)  {
            self.sevenDaysAgo = invoices.filter { invoice in
                if let date = dateFormatter.date(from: invoice.createdAt) {
                    return date >= sevenDaysAgo && date <= today
                }
                return false
            }
        }
        
        if let oneMonthAgo = Calendar.current.date(byAdding: .day, value: -30, to: today)  {
            self.oneMonthAgo = invoices.filter { invoice in
                if let date = dateFormatter.date(from: invoice.createdAt) {
                    return date >= oneMonthAgo && date <= today
                }
                return false
            }
        }
    }
    
    private func createBarItems(from sales: [InvoiceModel]) {
        let categoryCount = countCategories(in: sales)
        
        bestSellingCategories = ProductCategory.allCases.map { category in
            let count = categoryCount[category.rawValue, default: .zero]
            return BarItem(name: category.rawValue, value: Double(count))
        }
    }
    
    private func countCategories(in sales: [InvoiceModel]) -> [String: Int] {
        var categoryCount: [String: Int] = [:]
        
        sales.forEach { sale in
            sale.details.forEach { detail in
                if let productCategory = sale.products.first(where: { $0.name == detail.productName })?.category {
                    categoryCount[productCategory.rawValue, default: .zero] += detail.productQuantity
                }
            }
        }
        
        return categoryCount
    }
}
