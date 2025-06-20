//
//  CartographyMapFile+Preview.swift
//  MCMaps
//
//  Created by Marquis Kurt on 19-06-2025.
//

import SwiftUI

extension CartographyMapFile {
    // swiftlint:disable line_length
    static var preview: Self {
        CartographyMapFile(
            withManifest: MCMapManifest(
                name: "Augenwaldburg",
                worldSettings: MCMapManifestWorldSettings(version: "1.21", seed: 184719632014),
                pins: [
                    MCMapManifestPin(
                        position: CGPoint(x: 1847, y: 1847),
                        name: "Letztes Jahr",
                        color: .gray,
                        images: ["letztes-jahr"],
                        aboutDescription: "I am an old woman; I'm yesterday's news. I dream in black and white, and see it all through laser eyes.",
                        tags: []
                    ),
                    MCMapManifestPin(position: CGPoint(x: 1963, y: 1963), name: "KLB Electronics", color: .pink),
                    MCMapManifestPin(position: CGPoint(x: 2014, y: 2014), name: "Café Trommeln", color: .brown)
                ]
            ),
            images: [
                "letztes-jahr": NSDataAsset(name: "hero-sample")?.data ?? Data()
            ]
)
    }
    // swiftlint:enable line_length

    static var previewPin: MCMapManifestPin {
        Self.preview.manifest.pins[0]
    }
}
