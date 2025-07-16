//
//  CartographyGalleryWindowContext.swift
//  MCMaps
//
//  Created by Marquis Kurt on 16-07-2025.
//

import Foundation
import MCMapFormat

struct CartographyGalleryWindowContext: Codable, Hashable, Sendable {
    var imageCollection: [String: Data]

    static func empty() -> Self {
        CartographyGalleryWindowContext(imageCollection: [:])
    }

    init(imageCollection: [String: Data]) {
        self.imageCollection = imageCollection
    }

    init(file: CartographyMapFile) {
        imageCollection = file.images
    }
}
