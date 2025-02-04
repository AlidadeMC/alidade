//
//  CartographyMap.swift
//  MCMaps
//
//  Created by Marquis Kurt on 31-01-2025.
//

import Foundation

struct CartographyMap: Codable, Hashable {
    var seed: Int64
    var mcVersion: String
    var name: String
    var pins: [CartographyMapPin]
    var recentLocations: [CGPoint]? = []
}
