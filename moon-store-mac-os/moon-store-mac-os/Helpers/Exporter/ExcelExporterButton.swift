//
//  ExporterButton.swift
//  moon-store-mac-os
//
// Created by Jose Luna on 3/1/25.
//

import SwiftUI

private enum Constants {
    static let cornerRadius: CGFloat = 10
    static let padding: CGFloat = 10
}

struct ExcelExporterButton<CollectionType: Collection>: View {
    @State private var isPresented = false
    
    private let title: String
    private let fileName: String
    private let collection: CollectionType
    
    init(title: String, fileName: String, collection: CollectionType) {
        self.title = title
        self.fileName = fileName
        self.collection = collection
    }
    
    var body: some View {
        Button(title) {
            isPresented.toggle()
        }
        .buttonStyle(.plain)
        .padding(Constants.padding)
        .foregroundStyle(.msWhite)
        .background(.msPrimary, in: .rect(cornerRadius: Constants.cornerRadius))
        .fileExporter(
            isPresented: $isPresented,
            document: formattedDocument,
            contentType: .commaSeparatedText,
            defaultFilename: fileName
        ) { result in
            handleExportResult(fileName: fileName, result)
        }
    }
    
    private var formattedDocument: MSDocument {
        let stringFormat: String = {
            if let users = collection as? [UserModel] {
                FileFactory.makeUserStringFormatted(users: users)
            } else if let products = collection as? [ProductModel] {
                FileFactory.makeProductStringFormatted(products: products)
            } else if let invoices = collection as? [InvoiceModel] {
                FileFactory.makeInvoicesStringFormatted(invoices: invoices)
            } else { "Nothing" }
        }()
        return MSDocument(content: stringFormat)
    }
    
    private func handleExportResult(fileName: String, _ result: Result<URL, Error>) {
        switch result {
            case .success(let url):
                AlertPresenter.showAlert("\(fileName) exportado correctamente!")
                debugPrint("File exported to: \(url)")
            case .failure(let error):
                AlertPresenter.showAlert(with: error)
        }
    }
}
