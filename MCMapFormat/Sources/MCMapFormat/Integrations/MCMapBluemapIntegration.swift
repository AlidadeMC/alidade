//
//  MCMapBluemapIntegration.swift
//  MCMapFormat
//
//  Created by Marquis Kurt on 12-07-2025.
//

import Foundation

/// A structure that defines integrations with the Bluemap service.
///
/// Bluemap is a mapping plugin for Minecraft servers that provide an in-depth map with players, death markers, and general POIs.
public struct MCMapBluemapIntegration: MCMapIntegration {
    /// The key used to pull the integration from the package.
    public static let integrationKey = "Bluemap.json"

    /// A structure used to house which sets of markers to display on the map.
    public struct DisplayProperties: Codable, Sendable, Equatable, Hashable {
        private enum CodingKeys: String, CodingKey {
            case displayPlayers = "players"
            case displayMarkers = "markers"
            case displayDeathMarkers = "death"
        }

        /// Whether player position markers should be visible on the map.
        public var displayPlayers: Bool = true

        /// Whether markers provided by the server should be visible on the map.
        public var displayMarkers: Bool = true

        /// Whether player death markers should be visible on the map.
        public var displayDeathMarkers: Bool = true

        public init(displayPlayers: Bool = true, displayMarkers: Bool = true, displayDeathMarkers: Bool = true) {
            self.displayPlayers = displayPlayers
            self.displayMarkers = displayMarkers
            self.displayDeathMarkers = displayDeathMarkers
        }
    }

    /// A structure used to point to the correct world maps on the server.
    ///
    /// By default, most Paper servers will point to `world`, `world_nether`, and `world_end` for each of the
    /// respective dimensions. However, some servers might have these named differently; this structure can be used to
    /// configure the integration to point to the right places.
    public struct WorldMapping: Codable, Sendable, Equatable, Hashable {
        /// The map name corresponding to the overworld.
        public var overworld: String = "world"

        /// The map name corresponding to the Nether.
        public var nether: String = "world_nether"

        /// The map name corresponding to the End.
        public var end: String = "world_the_end"

        public init(overworld: String = "world", nether: String = "world_nether", end: String = "world_end") {
            self.overworld = overworld
            self.nether = nether
            self.end = end
        }
    }

    /// The base URL from where URL endpoints should be derived from.
    public var baseURL: String

    /// Whether this integration is enabled.
    public var enabled: Bool = false

    /// How often the markers should be refreshed.
    public var refreshRate: TimeInterval = 10

    /// The markers that should be displayed on the map.
    public var display: DisplayProperties = DisplayProperties()

    /// The mapping for worlds to corresponding Minecraft dimensions.
    public var mapping: WorldMapping = WorldMapping()


    public init(
        baseURL: String,
        enabled: Bool = false,
        refreshRate: TimeInterval = 10,
        display: DisplayProperties = DisplayProperties(),
        mapping: WorldMapping = WorldMapping()
    ) {
        self.baseURL = baseURL
        self.enabled = enabled
        self.refreshRate = refreshRate
        self.display = display
        self.mapping = mapping
    }
}
