//
//  DetailViewContainer.swift
//  Moon Store
//
//  Created by Jose Luna on 1/12/25.
//

import SwiftUI

struct ReportDetailContainer<Content: View, MSCollection: Collection>: View {
    @Binding private var showDetailView: Bool
    private let content: Content
    private let collection: MSCollection
    
    init(showDetailView: Binding<Bool>,
         collection: MSCollection,
         @ViewBuilder content: () -> Content) {
        _showDetailView = showDetailView
        self.collection = collection
        self.content = content()
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Button {
                    showDetailView = false
                } label: {
                    Label("Regresar", systemImage: "chevron.backward")
                }
                .buttonStyle(.plain)
                
                Spacer()
                
                ExcelExporterButton(
                    title: "Exportar",
                    fileName: "MS Reporte - \(Date.now)",
                    collection: collection
                )
            }
            
            content.frame(
                maxWidth: .infinity,
                maxHeight: .infinity,
                alignment: .leading
            )
        }
    }
}
