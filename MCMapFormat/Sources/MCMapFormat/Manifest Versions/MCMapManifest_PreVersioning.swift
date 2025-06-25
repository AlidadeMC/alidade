//
//  MCMapManifest_PreVersioning.swift
//  MCMaps
//
//  Created by Marquis Kurt on 12-05-2025.
//

import Foundation
import VersionedCodable

/// A representation of the basic Minecraft world map.
///
/// This is the default manifest structure if no version was provided at all.
///
/// > Important: Unless specifying this version is strictly required, refer to the ``MCMapManifest`` type instead,
/// > which points to the latest version.
public struct MCMapManifest_PreVersioning: Codable, Hashable, Sendable {
    /// The version of the Minecraft map manifest file.
    ///
    /// This is set to nil, since this structure represents versions of the file that did _not_ include the version.
    public var manifestVersion: Int?

    /// The seed used to generate the world in-game.
    public var seed: Int64

    /// A string representing the Minecraft version used to generate the world.
    ///
    /// World generations vary depending on the Minecraft version, despite having the same seed.
    public var mcVersion: String

    /// The player-assigned name of the world.
    ///
    /// This typically appears on iOS, and as part of the subtitle on macOS.
    public var name: String

    /// A list of player-created pins for notable areas in the world.
    public var pins: [MCMapManifestPin]

    /// A stack containing the most recent locations visited.
    ///
    /// This is usually filled with results from prior searches, and it shouldn't contain more than a few items at most.
    public var recentLocations: [CGPoint]? = []

    public init(
        manifestVersion: Int? = nil,
        seed: Int64,
        mcVersion: String,
        name: String,
        pins: [MCMapManifestPin],
        recentLocations: [CGPoint]? = nil
    ) {
        self.manifestVersion = manifestVersion
        self.seed = seed
        self.mcVersion = mcVersion
        self.name = name
        self.pins = pins
        self.recentLocations = recentLocations
    }
}

extension MCMapManifest_PreVersioning: VersionedCodable {
    public typealias PreviousVersion = NothingEarlier
    public typealias VersionSpec = CartographyMapVersionSpec

    public static let version: Int? = nil
}

extension MCMapManifest_PreVersioning: MCMapManifestProviding {
    /// The world settings associated with this Minecraft world map.
    ///
    /// This property is a "punch-up" migratory property used to handle forwards compatibility with newer manifest
    /// versions, such as ``MCMapManifest_v2``.
    public var worldSettings: MCMapManifestWorldSettings {
        get { return MCMapManifestWorldSettings(version: self.mcVersion, seed: self.seed) }
        set {
            self.mcVersion = newValue.version
            self.seed = newValue.seed
        }
    }

    /// A sample file used for debugging, testing, and preview purposes.
    ///
    /// This might also be used to create a map quickly via a template.
    public static let sampleFile = MCMapManifest_PreVersioning(
        seed: 123,
        mcVersion: "1.21.3",
        name: "My World",
        pins: [
            MCMapManifestPin(position: CGPoint(x: 0, y: 0), name: "Spawn")
        ])
}
