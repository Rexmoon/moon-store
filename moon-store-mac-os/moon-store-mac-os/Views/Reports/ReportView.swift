//
//  ReportView.swift
//  Moon Store
//
//  Created by Jose Luna on 1/12/25.
//

import SwiftUI

struct ReportView: View {
    @ObservedObject private var viewModel: ReportViewModel = .init()
    @Binding private var subNavigation: String?
    @State private var selectedSection: ReportSection = .generalInventory
    @State private var showDetailView: Bool = false
    
    init(subNavigation: Binding<String?>) {
        _subNavigation = subNavigation
    }
    
    var body: some View {
        ZStack {
            if !showDetailView {
                ScrollView(showsIndicators: false) {
                    ForEach(ReportSection.allCases) { section in
                        Button {
                            selectedSection = section
                            subNavigation = section.title
                            
                            withAnimation(.bouncy) {
                                self.showDetailView = true
                            }
                        } label: {
                            Text(section.title)
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background {
                                    RoundedRectangle(cornerRadius: 10)
                                        .fill(.msWhite)
                                }
                                .overlay {
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(.msGray, lineWidth: 2)
                                }
                        }
                        .buttonStyle(.plain)
                    }
                }
            }
            
            DetailViewContainer(showDetailView: $showDetailView, collection: collection) {
                buildView
            }
            .offset(x: showDetailView ? .zero : NSScreen.main?.frame.width ?? .zero)
            .animation(.spring, value: showDetailView)
        }
        .padding(20)
        .onChange(of: showDetailView) { _, isShow in
            if !isShow {
                subNavigation = nil
            }
        }
        .onDisappear {
            showDetailView = false
            subNavigation = nil
        }
    }
    
    private var collection: [Any] {
        switch selectedSection {
        case .generalInventory: viewModel.allProducts
        case .availableProducts: viewModel.availableStock
        case .outOfStockProducts: viewModel.outOfStock
        case .bestSellingCategories: viewModel.bestSellingCategories
        case .sales: viewModel.invoices
        case .weeklyProductSales: viewModel.sevenDaysAgo
        case .monthlyProductSales: viewModel.oneMonthAgo
        case .users: viewModel.users
        }
    }
    
    @ViewBuilder
    private var buildView: some View {
        switch selectedSection {
            case .generalInventory: ProductReportView(products: viewModel.allProducts)
            case .availableProducts: ProductReportView(products: viewModel.availableStock)
            case .outOfStockProducts: ProductReportView(products: viewModel.outOfStock)
            case .sales: InvoiceReportView(sales: viewModel.invoices)
            case .weeklyProductSales: InvoiceReportView(sales: viewModel.sevenDaysAgo, timeAgo: 7)
            case .monthlyProductSales: InvoiceReportView(sales: viewModel.oneMonthAgo, timeAgo: 30)
            case .users: UserReportView(users: viewModel.users)
            default: Text("Desarrollo en progreso")
        }
    }
}
