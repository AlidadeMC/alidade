//
//  MinecraftWorld+MCMapManifestWorldSettingsInit.swift
//  MCMaps
//
//  Created by Marquis Kurt on 08-06-2025.
//

import CubiomesKit
import MCMap

extension MinecraftWorld {
    init(worldSettings: MCMapManifestWorldSettings) throws {
        try self.init(version: worldSettings.version, seed: worldSettings.seed)
    }
}
