//
//  MCMapBluemapIntegrationExtensions.swift
//  MCMaps
//
//  Created by Marquis Kurt on 13-07-2025.
//

import MCMapFormat

struct BluemapDisplayProperties: OptionSet {
    let rawValue: Int

    public static let players = BluemapDisplayProperties(rawValue: 1 << 0)
    public static let markers = BluemapDisplayProperties(rawValue: 1 << 1)
    public static let deathMarkers = BluemapDisplayProperties(rawValue: 1 << 2)
}

extension MCMapBluemapIntegration {
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
