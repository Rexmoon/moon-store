//
//  InvoiceReportView.swift
//  Moon Store
//
//  Created by Jose Luna on 1/12/25.
//

import SwiftUI

struct InvoiceReportView: View {
    private let sales: [InvoiceModel]
    private let timeAgo: Int?
    
    init(sales: [InvoiceModel], timeAgo: Int? = nil) {
        self.sales = sales
        self.timeAgo = timeAgo
    }
    
    var body: some View {
        VStack(alignment: .trailing) {
            VStack(spacing: 5) {
                Grid { getGridRow() }
                
                MSDivider()
                
                salesList
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
    
    private var salesList: some View {
        ScrollView(showsIndicators: false) {
            Grid {
                ForEach(sales) { sale in
                    getGridRow(
                        cod: sale.id.description,
                        client: sale.customerName,
                        id: sale.customerIdentification,
                        date: sale.createdAt.formattedDate ?? "-",
                        total: getDoubleFormat(for: sale.totalAmount),
                        isHeader: false
                    )
                    
                    MSDivider()
                }
            }
        }
    }
    
    private func getGridRow(
        cod: String = "#",
        client: String = "Cliente",
        id: String = "Identificación",
        date: String = "Regitrada",
        total: String = "Total",
        isHeader: Bool = true
    ) -> some View {
        GridRow {
            Text(cod).frame(width: 50)
            
            Group {
                Text(date)
                Text(client)
                Text(id)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            
            Text(total).frame(width: 100)
        }
        .fontWeight(isHeader ? .bold : .regular)
    }
    
    private func totalItem(
        title: String,
        count: Int? = nil,
        total: Double? = nil
    ) -> some View {
        HStack {
            Text(title).bold()
            
            if let total {
                Text("\(getDoubleFormat(for: total))")
            }
            
            if let count {
                Text(count.description)
            }
        }
        .padding(.horizontal)
        .frame(height: 30)
        .background {
            RoundedRectangle(cornerRadius: 10)
                .fill(.msLightGray)
        }
    }
    
    private var footerView: some View {
        HStack {
            
            if let timeFilter {
               totalItem(title: timeFilter)
            }
            
            totalItem(
                title: "Total de facturas:",
                count: sales.count
            )
            
            totalItem(
                title: "Valor en ventas:",
                total: sales.map { $0.totalAmount }.reduce(.zero, +)
            )
        }
    }
    
    private var timeFilter: String? {
        let today = Date()
        
        guard let timeAgo,
              let date = Calendar.current.date(byAdding: .day,
                                               value: -timeAgo,
                                               to: today)
        else { return nil }
        return "\(date.formatted(date: .abbreviated, time: .omitted)) - \(today.formatted(date: .abbreviated, time: .omitted))"
    }
    
    func getDoubleFormat(for value: Double) -> String {
        return value.truncatingRemainder(dividingBy: 1) == .zero
        ? String(format: "$%.0f", value)
        : String(format: "$%.2f", value)
    }
}
