//
//  CartographyGalleryWindowContext.swift
//  MCMaps
//
//  Created by Marquis Kurt on 16-07-2025.
//

import Foundation
import MCMapFormat

/// A structure that describes the context for the gallery view.
///
/// This type is used to provide the minimal information required to display the ``CartographyGalleryView``. It
/// contains the collection of images provided by the file, and the base URL where the file is located.
struct CartographyGalleryWindowContext: Codable, Hashable, Sendable {
    /// The collection of images the file provides.
    var imageCollection: [String: Data]

    /// The URL from where the document is hosted.
    var documentBaseURL: URL?

    /// Provides an empty context.
    static func empty() -> Self {
        CartographyGalleryWindowContext(imageCollection: [:])
    }

    /// Create a context with a given collection of images and a base URL.
    /// - Parameter imageCollection: The collection of images to be displayed.
    /// - Parameter documentBaseURL: The URL from where the document is hosted.
    init(imageCollection: [String: Data], documentBaseURL: URL? = nil) {
        self.imageCollection = imageCollection
        self.documentBaseURL = documentBaseURL
    }

    /// Create a context from a file and base URL.
    /// - Parameter file: The file containing the image collection to display.
    /// - Parameter documentBaseURL: The URL from where the document is hosted.
    init(file: CartographyMapFile, documentBaseURL: URL?) {
        imageCollection = file.images
        self.documentBaseURL = documentBaseURL
    }
}
