//
//  BluemapPlayerModels.swift
//  MCMaps
//
//  Created by Marquis Kurt on 13-07-2025.
//

import Foundation

/// A structure used to denote a world position in a Bluemap model.
///
/// This type functions similarly to the `Point3D` type from CubiomesKit. However, it does not include any facilities
/// for manipulating points, and it cannot be used to interact with related types.
struct BluemapPosition: Codable {
    /// The position along the X axis.
    var x: Double
    /// The position along the Y axis.
    var y: Double

    /// The position along the Z axis.
    var z: Double
}

/// A player from a Bluemap world.
struct BluemapPlayer: Codable {
    /// A structure representing the player's rotation.
    struct Rotation: Codable {
        /// The pitch of the rotation.
        var pitch: Double

        /// The yaw of the rotation.
        var yaw: Double

        /// The roll of the rotation.
        var roll: Double
    }

    /// The player's Minecraft unique identifier.
    var uuid: UUID

    /// The player's Minecraft username.
    var name: String

    /// Whether the player is considered foreign on the current server.
    var foreign: Bool

    /// The player's current position in the world.
    var position: BluemapPosition

    /// The player's current rotation in the world.
    var rotation: Rotation
}

/// A model representing the response from the ``CartographyBluemapService/Endpoint/players`` endpoint.
struct BluemapPlayerResponse: Codable {
    /// The players that are currently active on the server.
    var players: [BluemapPlayer]
}
