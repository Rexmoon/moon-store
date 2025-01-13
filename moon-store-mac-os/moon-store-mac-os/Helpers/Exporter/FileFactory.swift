//
//  FileFactory.swift
//  moon-store-mac-os
//
// Created by Jose Luna on 3/1/25.
//

final class FileFactory {
    static func makeUserStringFormatted(users: [UserModel]) -> String {
        let header = "Nombre, Email, Roles"
        
        let formattedUsers = users.map { user in
            let role = user.roles.first?.name ?? "-"
            return "\(user.firstName), \(user.email), \(role)"
        }.joined(separator: "\n")
        
        return [header, formattedUsers].joined(separator: "\n")
    }
    
    static func makeProductStringFormatted(products: [ProductModel]) -> String {
        let header = "Nombre, Categoria, En Stock, Precio, Descripcion"
        
        let formattedProducts = products.map { product in
            "\(product.name), \(product.category.title), \(product.stock), \(product.salePrice), \(product.description)"
        }.joined(separator: "\n")
        
        return [header, formattedProducts].joined(separator: "\n")
    }
    
    static func makeInvoicesStringFormatted(invoices: [InvoiceModel]) -> String {
        let header = "Cliente, Identificacion, Fecha de venta"
        
        let formattedInvoices = invoices.map { invoice in
            let saleDate: String = invoice.createdAt.formattedDate ?? "-"
            let dateFormatted = saleDate.replacingOccurrences(of: ",", with: " ")
            return "\(invoice.customerName), \(invoice.customerIdentification), \(dateFormatted)"
        }.joined(separator: "\n")
        
        return [header, formattedInvoices].joined(separator: "\n")
    }
}
