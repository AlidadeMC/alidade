//
//  CartographyMapFile+Preview.swift
//  MCMaps
//
//  Created by Marquis Kurt on 19-06-2025.
//

import MCMap
import SwiftUI

// swiftlint:disable line_length

extension CartographyMapFile {
    /// A preview version of a map package.
    ///
    /// This is intended to be used for SwiftUI previews.
    static var preview: Self {
        CartographyMapFile(
            withManifest: MCMapManifest(
                name: "Augenwaldburg",
                worldSettings: MCMapManifestWorldSettings(version: "1.21", seed: 184_719_632_014),
                pins: []
            ),
            pins: [
                CartographyMapPin(
                    named: "Letztes Jahr",
                    at: CGPoint(x: 1847, y: 1847),
                    color: .gray,
                    icon: .home,
                    description:
                        "I am an old woman; I'm yesterday's news. I dream in black and white, and see it all through laser eyes.",
                    images: ["letztes-jahr"],
                    tags: []
                ),
                CartographyMapPin(
                    named: "KLB Electronics",
                    at: CGPoint(x: 1963, y: 1963),
                    color: .pink,
                    icon: .building
                ),
                CartographyMapPin(
                    named: "Café Trommeln",
                    at: CGPoint(x: 2014, y: 2014),
                    color: .brown,
                    icon: .emoji("☕️")
                ),
            ],
            images: [
                "letztes-jahr": NSDataAsset(name: "hero-sample")?.data ?? Data()
            ]
        )
    }

    /// A preview version of a map pin.
    ///
    /// This is intended to be used for SwiftUI previews.
    static var previewPin: CartographyMapPin {
        Self.preview.pins[0]
    }
}

// swiftlint:enable line_length
