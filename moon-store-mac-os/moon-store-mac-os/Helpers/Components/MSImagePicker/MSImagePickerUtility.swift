//
//  MSImagePickerViewModel.swift
//  moon-store-mac-os
//
//  Created by Jose Luna on 1/2/25.
//

import PhotosUI
import SwiftUI

@MainActor
final class MSImagePickerUtility {
    func loadImage(from item: PhotosPickerItem?) async -> Image? {
        guard let item else { return nil }
        do {
            return try await loadAsyncImage(from: item)
        } catch {
            AlertPresenter.showAlert(with: error)
            return nil
        }
    }
    
    private func loadAsyncImage(from item: PhotosPickerItem) async throws -> Image {
        do {
            guard let image = try await item.loadTransferable(type: Image.self)
            else { throw MSError.unsupportedFormat }
            return image
        } catch {
            throw MSError.invalidSelection
        }
    }
}
