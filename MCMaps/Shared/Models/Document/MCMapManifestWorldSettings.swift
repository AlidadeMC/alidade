//
//  MCMapManifestWorldSettings.swift
//  MCMaps
//
//  Created by Marquis Kurt on 08-05-2025.
//

import Foundation

/// A structure representing the various world settings available to a Minecraft world.
///
/// This structure was first introduced with ``MCMapManifest_v2`` as a means of better grouping world settings such as
/// the Minecraft version and seed. The original version of the manifest has a migratory version of this with
/// ``MCMapManifest_v1/worldSettings``.
struct MCMapManifestWorldSettings: Codable, Hashable, Sendable {
    /// A string representing the Minecraft version used to generate the world.
    ///
    /// World generations vary depending on the Minecraft version, despite having the same seed.
    var version: String

    /// The seed used to generate the world in-game.
    var seed: Int64

    /// Whether to use large biomes during world generation.
    var largeBiomes: Bool = false
}
