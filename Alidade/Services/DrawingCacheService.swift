//
//  DrawingCacheService.swift
//  Alidade
//
//  Created by Marquis Kurt on 22-03-2026.
//

import ImageProcessing
import MCMap
import PencilKit
import SwiftUI

#if canImport(AppKit)
    private typealias DrawingImageType = NSImage

    extension Image {
        fileprivate init(drawingImage: DrawingImageType) {
            self.init(nsImage: drawingImage)
        }
    }
#elseif canImport(UIKit)
    private typealias DrawingImageType = UIImage

    extension Image {
        fileprivate init(drawingImage: DrawingImageType) {
            self.init(uiImage: drawingImage)
        }
    }
#endif

actor DrawingCacheService {
    private var cache: NSCache<NSString, DrawingImageType>

    init(limit maxBytes: Int = 100 * 1_000_000) {
        cache = NSCache()
        cache.totalCostLimit = maxBytes
    }

    func image(for drawing: CartographyDrawing, scale: CGFloat = 1, accessibilityLabel: String = "") -> Image {
        let key = string(for: drawing)
        if let item = cache.object(forKey: key) {
            return Image(drawingImage: item)
        }
        let pkDrawing = drawing.data.drawing
        let image = pkDrawing.image(from: pkDrawing.bounds, scale: scale)
        cache.setObject(image, forKey: key, cost: pkDrawing.dataRepresentation().count)
        return Image(drawingImage: image)
    }

    private func string(for drawing: CartographyDrawing) -> NSString {
        return drawing.id.uuidString as NSString
    }
}
