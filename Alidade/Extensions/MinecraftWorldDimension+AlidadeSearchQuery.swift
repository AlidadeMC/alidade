//
//  MinecraftWorldDimension+AlidadeSearchQuery.swift
//  MCMaps
//
//  Created by Marquis Kurt on 19-10-2025.
//

import AlidadeSearchEngine
import CubiomesKit

extension MinecraftWorld.Dimension {
    init?(query: AlidadeSearchQuery) {
        guard let dimension = query.dimension else { return nil }
        switch dimension.localizedLowercase {
        case "overworld":
            self = .overworld
        case "nether":
            self = .nether
        case "end":
            self = .end
        default:
            return nil
        }
    }
}
