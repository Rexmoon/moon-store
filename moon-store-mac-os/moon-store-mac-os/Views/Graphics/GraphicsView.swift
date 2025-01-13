//
//  GraphicsView.swift
//  moon-store-mac-os
//
// Created by Jose Luna on 6/1/25.
//

import SwiftUI

private enum Constants {
    static let mainSpacing: CGFloat = 20
    static let pdfFileName: String = "MS Gráficos - "
}

struct GraphicsView: View {
    @StateObject private var viewModel: GraphicsViewModel = .init()
    
    var body: some View {
        VStack(spacing: Constants.mainSpacing) {
            HStack {
                ForEach(viewModel.cardGraphicModels) { info in
                    InformationCard(info: info)
                }
            }
            
            BarChart(
                title: localized(.mostProductsSold),
                data: viewModel.mostProductsSold,
                color: .msPrimary
            )
            
            HStack {
                AreaChart(
                    title: localized(.invoicesByWeekday),
                    data: viewModel.invoicesByWeekday,
                    color: .msGreen
                )
                
                AreaChart(
                    title: localized(.mostCategoriesSold),
                    data: viewModel.mostCategoriesSold,
                    color: .msOrange
                )
            }
        }
        .padding()
        .showSpinner($viewModel.isLoading)
        .toolbar {
            PDFExporterButton(fileName: localized(.pdfFileName)) {
                self
            }
        }
    }
}

// MARK: - Localized

extension GraphicsView {
    private enum LocalizedKey {
        case mostProductsSold
        case invoicesByWeekday
        case mostCategoriesSold
        case pdfFileName
    }
    
    private func localized(_ key: LocalizedKey) -> String {
        switch key {
            case .mostProductsSold: "Productos mas vendidos"
            case .invoicesByWeekday: "Facturas Generadas"
            case .mostCategoriesSold: "Categorías mas vendidas"
            case .pdfFileName: "\(Constants.pdfFileName)\(Date.now)"
        }
    }
}

// MARK: Preview

#Preview {
    GraphicsView()
}
