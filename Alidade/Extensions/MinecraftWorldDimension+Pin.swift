//
//  MinecraftWorldDimension+Pin.swift
//  MCMaps
//
//  Created by Marquis Kurt on 13-08-2025.
//

import CubiomesKit
import MCMap

extension MinecraftWorld.Dimension {
    init(fromPinDimension pinDimension: CartographyMapPin.Dimension) {
        switch pinDimension {
        case .overworld:
            self = .overworld
        case .nether:
            self = .nether
        case .end:
            self = .end
        }
    }
}
