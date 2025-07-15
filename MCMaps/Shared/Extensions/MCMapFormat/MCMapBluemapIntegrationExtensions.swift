//
//  MCMapBluemapIntegrationExtensions.swift
//  MCMaps
//
//  Created by Marquis Kurt on 13-07-2025.
//

import MCMapFormat

/// An option set that describes what should be displayed on the map from Bluemap.
struct BluemapDisplayProperties: OptionSet {
    let rawValue: Int

    /// The map should show active player marker annotations.
    public static let players = BluemapDisplayProperties(rawValue: 1 << 0)

    /// The map should show markers from the current world.
    public static let markers = BluemapDisplayProperties(rawValue: 1 << 1)

    /// The map should show markers for where players have died from the current world.
    public static let deathMarkers = BluemapDisplayProperties(rawValue: 1 << 2)
}

extension MCMapBluemapIntegration {
    /// The display options for the current integration.
    var displayOptions: BluemapDisplayProperties {
        var options = BluemapDisplayProperties()
        if display.displayDeathMarkers {
            options.insert(.deathMarkers)
        }
        if display.displayMarkers {
            options.insert(.markers)
        }
        if display.displayPlayers {
            options.insert(.players)
        }
        return options
    }
}
