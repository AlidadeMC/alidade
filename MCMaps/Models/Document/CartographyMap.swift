//
//  CartographyMap.swift
//  MCMaps
//
//  Created by Marquis Kurt on 31-01-2025.
//

import Foundation

/// A representation of the basic Minecraft world map.
struct CartographyMap: Codable, Hashable, Sendable {
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
