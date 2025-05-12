//
//  MCMapManifest_v2.swift
//  MCMaps
//
//  Created by Marquis Kurt on 08-05-2025.
//

import Foundation
import VersionedCodable

/// A representation of the basic Minecraft world map.
///
/// > Important: Unless specifying this version is strictly required, refer to the ``MCMapManifest`` type instead,
/// > which points to the latest version.
struct MCMapManifest_v2: Codable, Hashable, Sendable {
    private enum CodingKeys: String, CodingKey {
        case name, pins, recentLocations, manifestVersion
        case worldSettings = "world"
    }

    /// The Minecraft world map package version.
    var manifestVersion: Int? = 2

    /// The player-assigned name of the world.
    ///
    /// This typically appears on iOS and iPadOS, and as part of the subtitle on macOS.
    var name: String

    /// The world settings associated with this Minecraft world map.
    var worldSettings: MCMapManifestWorldSettings

    /// A list of player-created pins for notable areas in the world.
    var pins: [MCMapManifestPin]

    /// A stack containing the most recent locations visited.
    ///
    /// This is usually filled with results from prior searches, and it shouldn't contain more than a few items at most.
    var recentLocations: [CGPoint]? = []
}

extension MCMapManifest_v2: VersionedCodable {
    typealias PreviousVersion = MCMapManifest_v1
    typealias VersionSpec = CartographyMapVersionSpec

    static let version: Int?  = 2

    /// A string representing the Minecraft version used to generate the world.
    ///
    /// World generations vary depending on the Minecraft version, despite having the same seed.
    ///
    /// > Important: This property is deprecated and provided as a migratory convenience. Use the
    /// > ``worldSettings-swift.property`` property to access world data.
    @available(*, deprecated, renamed: "worldSettings.version")
    var mcVersion: String {
        get { return worldSettings.version }
        set { worldSettings.version = newValue }
    }

    /// The seed used to generate the world in-game.
    ///
    /// > Important: This property is deprecated and provided as a migratory convenience. Use the
    /// > ``worldSettings-swift.property`` property to access world data.
    @available(*, deprecated, renamed: "worldSettings.seed")
    var seed: Int64 {
        get { return worldSettings.seed }
        set { worldSettings.seed = newValue }
    }

    init(from previous: PreviousVersion) throws {
        self.manifestVersion = previous.manifestVersion
        self.name = previous.name
        self.worldSettings = MCMapManifestWorldSettings(version: previous.mcVersion, seed: previous.seed)
        self.pins = previous.pins
        self.recentLocations = previous.recentLocations
    }
}

extension MCMapManifest_v2: MCMapManifestProviding {
    static let sampleFile = MCMapManifest_v2(
        manifestVersion: 2,
        name: "My World",
        worldSettings: MCMapManifestWorldSettings(version: "1.21.3", seed: 123),
        pins: [
            MCMapManifestPin(position: .zero, name: "Spawn")
        ]
    )
}
