//
//  ProductListView.swift
//  moon-store-mac-os
//
//  Created by Diana Zeledon on 11/12/24.
//

import SwiftUI

struct ProductListView: View {
    private typealias Constants = ProductListConstants
    
    @StateObject private var viewModel: ProductListViewModel = .init()
    @State private var showAddProductModal: Bool = false
    @State private var showSupplyProductModal: Bool = false
    @State private var showDetailProductModal: Bool = false

    var body: some View {
        VStack(spacing: Constants.spacing) {
            headerView
            productTableView
            
            if viewModel.productList.isNotEmpty {
                Text("Total: \(viewModel.productCount)")
                    .frame(height: Constants.iconSize)
                    .padding(.horizontal)
                    .background(.msWhite, in: .capsule)
                    .foregroundStyle(.msBlack)
                    .frame(maxWidth: .infinity, alignment: .trailing)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .padding()
        .background(.msLightGray)
        .showSpinner($viewModel.isLoading)
    }
    
    // MARK: - Header View
    
    private var headerView: some View {
        HStack {
            SearchView(searchText: $viewModel.searchText)
                .leadingInfinity()
            
            ExcelExporterButton(title: "Exportar",
                           fileName: "Products",
                           collection: viewModel.productList)
            .disabled(viewModel.cannotExportProducts)
            
            Button("Agregar Producto", systemImage: Constants.plusIcon) {
                showAddProductModal.toggle()
            }
            .buttonStyle(.plain)
            .padding(Constants.cornerRadius)
            .background(.msPrimary, in: .rect(cornerRadius: Constants.cornerRadius))
            .foregroundStyle(.msWhite)
        }
        .sheet(isPresented: $showAddProductModal) {
            AddProductView()
        }
        .sheet(isPresented: $showSupplyProductModal) {
            SupplyProductView(productName: viewModel.productSelected?.name ?? "") { quantity in
                viewModel.supplyProductSelectedProduct(quantity)
            }
        }
        .sheet(isPresented: $showDetailProductModal) {
            if let product = viewModel.productSelected {
                ProductDetailView(product: product)
            }
        }
    }
    
    // MARK: - Table View
    
    private var productTableView: some View {
        VStack(spacing: .zero) {
            headerTableView
            productList
        }
        .overlay {
            RoundedRectangle(cornerRadius: Constants.cornerRadius)
                .stroke(.msGray)
            
            if viewModel.shouldShowEmptyView {
                MSEmptyListView { viewModel.getProducts() }
            }
        }
        .clipShape(.rect(cornerRadius: Constants.cornerRadius))
    }

    // MARK: - Header Table View
    
    private var productList: some View {
        ScrollView(showsIndicators: false) {
            Grid(horizontalSpacing: .zero, verticalSpacing: .zero) {
                ForEach(viewModel.productList.indices, id: \.self) { index in
                    productRowView(
                        viewModel.productList[index],
                        isEvenRow: index.isMultiple(of: Constants.ProductRow.pairNumber)
                    )
                }
            }
        }
        .fixedSize(horizontal: false, vertical: true)
    }
    
    // MARK: - Header Table View

    private var headerTableView: some View {
        Grid(horizontalSpacing: .zero, verticalSpacing: .zero) {
            GridRow {
                ForEach(ProductTableTitle.allCases) { header in
                    Text(header.title)
                        .frame(
                            maxWidth: header.width,
                            alignment: header == .product ? .leading : .center
                        )
                        .foregroundStyle(.msBlack)
                        .padding(header.padding)
                        .font(.body.bold())
                }
            }
        }
        .frame(height: Constants.ProductRow.height)
        .background(.msWhite)
    }

    // MARK: - Table Row View

    private func productRowView(_ product: ProductModel, isEvenRow: Bool) -> some View {
        GridRow {
            HStack {
                MSAsyncImage(
                    url: product.images.first ?? "",
                    size: Constants.iconSize
                )
                
                Text(product.name)
                    .leadingInfinity()
                    .foregroundStyle(.msBlack)
                    .lineLimit(Constants.ProductRow.lineLimit)
            }
            .frame(maxWidth: .infinity)
            .padding(.leading)
            
            Text(product.category.title)
                .padding(Constants.ProductRow.padding)
                .foregroundStyle(product.category.color)
                .background(product.category.color.opacity(Constants.ProductRow.opacity), in: .capsule)
                .frame(width: Constants.ProductRow.categorySize)
            
            Text(product.stock.description)
                .foregroundStyle(.msDarkGray)
                .frame(width: Constants.ProductRow.stockSize)
            
            Text(product.salePrice.description)
                .foregroundStyle(.msDarkGray)
                .frame(width: Constants.ProductRow.stockSize)
            
            optionsView(for: product)
        }
        .frame(height: Constants.ProductRow.height)
        .background(isEvenRow ? .msLightGray : .msWhite)
        .onTapGesture {
            viewModel.updateSelectedProduct(with: product.id)
            showDetailProductModal.toggle()
        }
    }

    // MARK: - Product options view

    private func optionsView(for product: ProductModel) -> some View {
        HStack(spacing: Constants.ProductRow.spacing) {
            Button(Constants.ProductRow.optionTitle) {
                showSupplyProductModal.toggle()
                viewModel.updateSelectedProduct(with: product.id)
            }
            .buttonStyle(.plain)
            .foregroundStyle(.msPrimary)
            .underline()

            Button {
                viewModel.showDeleteAlert(with: product.id)
            } label: {
                Image(systemName: Constants.ProductRow.trashIcon)
                    .resizable()
                    .frame(square: Constants.ProductRow.iconSize)
                    .foregroundStyle(.msOrange)
            }
            .buttonStyle(.plain)
        }
        .frame(width: Constants.ProductRow.optionsSise)
        .padding(.trailing)
    }
}

