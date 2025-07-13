//
//  BluemapPlayerModels.swift
//  MCMaps
//
//  Created by Marquis Kurt on 13-07-2025.
//

import Foundation

struct BluemapPosition: Codable {
    var x: Double
    var y: Double
    var z: Double
}

struct BluemapPlayer: Codable {
    struct Rotation: Codable {
        var pitch: Double
        var yaw: Double
        var roll: Double
    }

    var uuid: UUID
    var name: String
    var foreign: Bool
    var position: BluemapPosition
    var rotation: Rotation
}

struct BluemapPlayerResponse: Codable {
    var players: [BluemapPlayer]
}
