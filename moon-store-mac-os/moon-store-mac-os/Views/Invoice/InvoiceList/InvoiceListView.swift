//
//  InvoiceListView.swift
//  moon-store-mac-os
//
//  Created by Jose Luna on 1/8/25.
//

import SwiftUI

private enum Constants {
    static let columnsNumber: Int = 4
    static let historyGridPadding: CGFloat = 30
    static let fileName: String = "Historial de ventas"
    static let reloadIcon: String = "arrow.clockwise"
    static let pair: Int = 2
    static let cornerRadius: CGFloat = 10
    static let optionSize: CGFloat = 100
    static let rowHeight: CGFloat = 40
}

struct InvoiceListView: View {
    @ObservedObject private var viewModel: InvoiceListViewModel = .init()
    
    var body: some View {
        VStack {
            ExcelExporterButton(
                title: localized(.exporterButton),
                fileName: Constants.fileName,
                collection: viewModel.invoiceList
            )
            .disabled(viewModel.cannotExportInvoice)
            .frame(maxWidth: .infinity, alignment: .trailing)
            .padding([.top, .trailing])
            
            historyList
                .padding(.horizontal)
            
            TextCounterView(viewModel.invoiceCount)
        }
        .showSpinner($viewModel.isLoading)
        .frame(maxHeight: .infinity, alignment: .top)
        .toolbar {
            ToolbarItem(placement: .destructiveAction) {
                Button {
                    viewModel.getInvoices()
                } label: {
                    Image(systemName: Constants.reloadIcon)
                        .foregroundStyle(.msPrimary)
                }
            }
        }
    }
    
    // MARK: - Header List View
    
    private var headerListView: some View {
        Grid(horizontalSpacing: .zero) {
            GridRow {
                Group {
                    Text(localized(.clientRowTitle))
                        .padding(.leading)
                    
                    Text(localized(.idRowTitle))
                    Text(localized(.dateRowTitle))
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                
                Text(" ")
                    .frame(width: Constants.optionSize)
                    .padding(.trailing)
            }
        }
        .frame(height: Constants.rowHeight)
        .background(.msWhite)
    }
        
    // MARK: - History List View
    
    private var historyList: some View {
        VStack {
            headerListView
            
            if viewModel.shouldShowEmptyView {
                MSEmptyListView {
                    viewModel.getInvoices()
                }
            } else {
                itemRows
            }
        }
        .clipShape(.rect(cornerRadius: Constants.cornerRadius))
        .overlay {
            RoundedRectangle(cornerRadius: Constants.cornerRadius)
                .stroke(.msGray)
        }
    }
    
    // MARK: - Item View
    
    private var itemRows: some View {
        GridRow {
            ScrollView(showsIndicators: false) {
                Grid(horizontalSpacing: .zero, verticalSpacing: .zero) {
                    ForEach(Array(viewModel.invoiceList.enumerated()), id: \.element.id) { index, invoice in
                        GridRow {
                            Group {
                                Text(invoice.customerName)
                                    .padding(.leading)
                                Text(invoice.customerIdentification)
                                Text(invoice.createdAt.formattedDate ?? localized(.invalidDate))
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                            
                            Button(localized(.showInvoiceButton)) {
                                viewModel.updateInvoiceSelected(with: invoice.id)
                            }
                            .buttonStyle(.plain)
                            .underline()
                            .frame(width: Constants.optionSize, alignment: .trailing)
                            .padding(.trailing)
                        }
                        .frame(height: Constants.rowHeight)
                        .background(index % Constants.pair == .zero
                                    ? .clear
                                    : .msWhite)
                    }
                }
                .sheet(isPresented: $viewModel.showInvoicePreview) {
                    if let sale = viewModel.selectedSale {
                        InvoicePreviewView(invoiceSale: sale)
                    }
                }
            }
        }
    }
}

// MARK: - Localized

extension InvoiceListView {
    private enum InvoiceListViewKey {
        case exporterButton
        case clientRowTitle
        case idRowTitle
        case dateRowTitle
        case invalidDate
        case showInvoiceButton
    }
    
    private func localized(_ key: InvoiceListViewKey) -> String {
        switch key {
            case .exporterButton: "Exportar"
            case .clientRowTitle: "Cliente"
            case .idRowTitle: "Identificatión"
            case .dateRowTitle: "Fecha de venta"
            case .invalidDate: "Fecha inválida"
            case .showInvoiceButton: "Ver factura"
        }
    }
}

#Preview {
    InvoiceListView()
}
