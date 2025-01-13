//
//  MSDocument.swift
//  moon-store-mac-os
//
// Created by Jose Luna on 3/1/25.
//

import SwiftUI
import UniformTypeIdentifiers

struct MSDocument: FileDocument {
    static let readableContentTypes: [UTType] = [.pdf, .commaSeparatedText]
    private let content: String
    
    init(content: String) {
        self.content = content
    }
    
    init(configuration: ReadConfiguration) throws {
        guard let data = configuration.file.regularFileContents else {
            throw CocoaError(.fileReadCorruptFile)
        }
        self.content = String(decoding: data, as: UTF8.self)
    }
    
    func fileWrapper(configuration: WriteConfiguration) throws -> FileWrapper {
        guard let data = content.data(using: .utf8) else {
            throw CocoaError(.fileWriteInapplicableStringEncoding)
        }
        return FileWrapper(regularFileWithContents: data)
    }
}
