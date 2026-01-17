//
//  CartographyGalleryWindowContextTests.swift
//  MCMaps
//
//  Created by Marquis Kurt on 05-08-2025.
//

import Foundation
import MCMap
import Testing

@testable import Alidade

struct CartographyGalleryWindowContextTests {
    @Test func empty() async throws {
        let emptyContext = CartographyGalleryWindowContext.empty()
        #expect(emptyContext.imageCollection.isEmpty)
        #expect(emptyContext.documentBaseURL == nil)
    }

    @Test func initFromFile() async throws {
        let file = CartographyMapFile(
            withManifest: MCMapManifest_v2(
                name: "My World",
                worldSettings: MCMapManifestWorldSettings(version: "1.21", seed: 123),
                pins: []
            ),
            images: ["example": Data()]
        )
        let context = CartographyGalleryWindowContext(file: file, documentBaseURL: nil)
        #expect(!context.imageCollection.isEmpty)
    }
}
