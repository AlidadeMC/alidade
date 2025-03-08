//
//  BiomeID+Name.swift
//  MCMaps
//
//  Created by Marquis Kurt on 07-03-2025.
//

import CubiomesKit
import CubiomesInternal
import Foundation

enum BiomeNameError: Error {
    case invalidMinecraftVersion
    case invalidBiomeValue
}

extension MinecraftBiome {
    init?(string: String, mcVersion: String) throws(BiomeNameError) {
        // NOTE(alicerunsonfedora): Closest we can get to a CaseIterable for the struct... gonna be fuckin' janky as
        // all hell...
        for rawV in ocean.rawValue...pale_garden.rawValue {
            let biome = MinecraftBiome(rawValue: rawV)
            do {
                let name = try biome.name(for: mcVersion)
                if name == string {
                    self = biome
                    return
                }
            } catch {
                continue
            }
        }
        return nil
    }

    func name(for versionString: String) throws(BiomeNameError) -> String {
        let mcVersion = str2mc(versionString)
        if mcVersion == MC_UNDEF.rawValue {
            throw .invalidMinecraftVersion
        }
        return try getName(for: MCVersion(UInt32(mcVersion)))
    }

    private func getName(for version: MCVersion) throws(BiomeNameError) -> String {
        guard let potentialID = biome2str(Int32(version.rawValue), self.rawValue) else {
            throw .invalidBiomeValue
        }
        let originalID = String(cString: potentialID)
        var nameComponents = originalID.components(separatedBy: "_")
        nameComponents = nameComponents.map(\.localizedCapitalized)
        return nameComponents.joined(separator: " ")
    }
}
