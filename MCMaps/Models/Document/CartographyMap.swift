//
//  CartographyMap.swift
//  MCMaps
//
//  Created by Marquis Kurt on 31-01-2025.
//

import Foundation
import VersionedCodable

/// A typealias that points to the latest manifest version.
///
/// This should be used in conjunction with ``CartographyMapFile`` to ensure that the latest version of the manifest is
/// being used. Whenever encoding to and decoding from this type, use the `encode(versioned:)` and
/// `decode(versioned:data:)` methods from `VersionedCodable`, respectively.
typealias MCMapManifest = CartographyMap

/// A representation of the basic Minecraft world map.
///
/// This is the default manifest structure if no specific version was provided.
///
/// > Important: Unless specifying this version is strictly required, refer to the ``MCMapManifest`` type instead,
/// > which points to the latest version.
struct CartographyMap: Codable, Hashable, Sendable {
    /// The Minecraft world map package version.
    var manifestVersion: Int? = 1

    /// The seed used to generate the world in-game.
    var seed: Int64

    /// A string representing the Minecraft version used to generate the world.
    ///
    /// World generations vary depending on the Minecraft version, despite having the same seed.
    var mcVersion: String

    /// The player-assigned name of the world.
    ///
    /// This typically appears on iOS, and as part of the subtitle on macOS.
    var name: String

    /// A list of player-created pins for notable areas in the world.
    var pins: [CartographyMapPin]

    /// A stack containing the most recent locations visited.
    ///
    /// This is usually filled with results from prior searches, and it shouldn't contain more than a few items at most.
    var recentLocations: [CGPoint]? = []
}

extension CartographyMap: VersionedCodable {
    typealias PreviousVersion = NothingEarlier
    typealias VersionSpec = CartographyMapVersionSpec

    static let version: Int? = 1
}

/// A structure used to denote the version path in Codable structures.
///
/// This should be used with any manifest files that conform to `VersionedCodable` via the `VersionSpec` typealias.
struct CartographyMapVersionSpec: VersionPathSpec, Sendable {
    nonisolated(unsafe) static let keyPathToVersion: KeyPath<CartographyMapVersionSpec, Int?> =
        \Self.manifestVersion

    /// The Minecraft world map package version.
    var manifestVersion: Int?

    init(withVersion version: Int?) {
        self.manifestVersion = version
    }
}
