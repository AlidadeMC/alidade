//
//  CartographyMapFeatures.swift
//  MCMaps
//
//  Created by Marquis Kurt on 19-06-2025.
//

import Foundation

/// An option set used to surface what features are supported by a MCMap package.
struct CartographyMapFeatures {
    /// The raw value representation.
    let rawValue: Int
}

extension CartographyMapFeatures: OptionSet {
    /// The file supports the core searching capabilities.
    static let coreSearch = CartographyMapFeatures(rawValue: 1 << 0)

    /// The file supports the core pinning capabilities.
    static let corePinning = CartographyMapFeatures(rawValue: 1 << 1)

    /// The file supports generating worlds with the "large biomes" feature.
    static let largeBiomes = CartographyMapFeatures(rawValue: 1 << 2)

    /// The file supports tags in pinned places.
    static let pinTagging = CartographyMapFeatures(rawValue: 1 << 3)

    /// The default set of features for the minimum version supported.
    static let minimumDefault: CartographyMapFeatures = [.coreSearch, .corePinning]

    /// Create a feature set from a file.
    init(representing file: CartographyMapFile) {
        self = .minimumDefault

        guard let manifestVersion = file.manifest.manifestVersion else { return }
        switch manifestVersion {
        case 2...:
            self.insert(.pinTagging)
            self.insert(.largeBiomes)
        default:
            break
        }
    }
}
