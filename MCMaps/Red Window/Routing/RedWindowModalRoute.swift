//
//  RedWindowModalRoute.swift
//  MCMaps
//
//  Created by Marquis Kurt on 24-06-2025.
//

/// An enumeration of the various modals that can be routed.
enum RedWindowModalRoute: Identifiable, Sendable, Hashable {
    var id: Self { self }

    /// The player is requesting to move to a specific location on the map.
    case warpToLocation

    /// The player is requesting to create a pin.
    case createPin
}
