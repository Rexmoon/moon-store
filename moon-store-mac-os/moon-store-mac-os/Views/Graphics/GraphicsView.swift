//
//  GraphicsView.swift
//  moon-store-mac-os
//
//  Created by Steven Santeliz on 6/1/25.
//

import SwiftUI

private enum Constants {
    static let mainSpacing: CGFloat = 20
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
                title: "Productos mas vendidos",
                data: viewModel.mostProductsSold,
                color: .msPrimary
            )
            
            AreaChart(
                title: "Facturas Generadas",
                data: viewModel.invoicesByWeekday,
                color: .msGreen
            )
        }
        .padding()
        .showSpinner($viewModel.isLoading)
    }
}
