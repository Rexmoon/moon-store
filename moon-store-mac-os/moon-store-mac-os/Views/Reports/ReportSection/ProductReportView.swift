//
//  ProductReportView.swift
//  Moon Store
//
//  Created by Jose Luna on 1/12/25.
//

import SwiftUI

struct ProductReportView: View {
    private let products: [ProductModel]
    
    init(products: [ProductModel]) {
        self.products = products
    }
    
    var body: some View {
        VStack(alignment: .trailing) {
            VStack(spacing: 5) {
                Grid { getGridRow() }
                
                MSDivider()
                
                productList
            }
            .padding()
            .background {
                RoundedRectangle(cornerRadius: 10)
                    .fill(.msWhite)
            }
            
            footerView
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .trailing)
    }
    
    private var isAllProducts: Bool { !isAvailable && !isOutOfStock }
    
    private var isOutOfStock: Bool { products.allSatisfy { $0.stock <= .zero } }
    
    private var isAvailable: Bool { products.allSatisfy { $0.stock > .zero } }
    
    private var productList: some View {
        ScrollView(showsIndicators: false) {
            Grid {
                ForEach(products) { product in
                    getGridRow(
                        cod: product.id.description,
                        name: product.name,
                        stock: product.stock > .zero ? product.stock.description : "Agotado",
                        desciption: product.description,
                        price: "$\(product.salePrice.description)",
                        isHeader: false
                    )
                    
                    MSDivider()
                }
            }
        }
    }
    
    private func totalItem(
        title: String,
        count: Int = .zero,
        total: Double? = nil
    ) -> some View {
        HStack {
            Text(title).bold()
            
            if let total {
                Text("$\(total.description)")
            } else {
                Text(count.description)
            }
        }
        .padding(.horizontal)
        .frame(height: 30)
        .background {
            RoundedRectangle(cornerRadius: 10)
                .fill(.msGray)
        }
    }
    
    private var footerView: some View {
        HStack {
            if isAllProducts {
                totalItem(
                    title: "Total Productos:",
                    count: products.count
                )
            }
            
            if isAvailable || isAllProducts {
                totalItem(
                    title: "Disponibles:",
                    count: products.filter { $0.stock > .zero}.count
                )
            }
            
            if isOutOfStock || isAllProducts {
                totalItem(
                    title: "Agotados:",
                    count: products.filter { $0.stock <= .zero}.count
                )
            }
            
            totalItem(
                title: "Valor Inventario:",
                total: inventarioMoney
            )
        }
    }
    
    private var inventarioMoney: Double {
        products.reduce(.zero) { total, product in
            total + Double(product.stock) * product.salePrice
        }
    }

    
    private func getGridRow(
        cod: String = "Cod",
        name: String = "Nombre",
        stock: String = "Stock",
        desciption: String = "Descripción",
        price: String = "Valor",
        isHeader: Bool = true
    ) -> some View {
        GridRow {
            Text(cod).frame(width: 40)
            
            Text(name)
                .frame(width: 150)
                .multilineTextAlignment(.center)
            
            Text(stock).frame(width: 100)
            
            Text(price).frame(width: 100)
            
            Text(desciption).frame(maxWidth: .infinity, alignment: .leading)
        }
        .fontWeight(isHeader ? .bold : .regular)
    }
}
