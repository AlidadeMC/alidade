//
//  MinecraftBiome.swift
//  CubiomesKit
//
//  Created by Marquis Kurt on 12-03-2025.
//

@_exported import CubiomesInternal
import Foundation

/// An enumeration for all available biomes in Minecraft.
public typealias MinecraftBiome = BiomeID

public extension MinecraftBiome {
    /// Initializes a biome from a given ID string and Minecraft version.
    ///
    /// - Parameter string: The string value to parse and create an enumeration from.
    /// - Parameter minecraftVersion: The Minecraft version relevant to the biome.
    init?(_ string: String, minecraftVersion: MinecraftVersion) {
        for rawV in ocean.rawValue...pale_garden.rawValue {
            let biome = MinecraftBiome(rawValue: rawV)
            guard let name = biome2str(minecraftVersion.versionValue, rawV) else {
                continue
            }
            if String(cString: name) == string {
                self = biome
                return
            }
        }
        return nil
    }

    /// Initializes a biome from a localized string and Minecraft version.
    ///
    /// - Parameter localizedString: The string value to parse and create an enumeration from.
    /// - Parameter mcVersion: The Minecraft version relevant to the biome.
    init?(localizedString: String, mcVersion: String) {
        var nameComponents = localizedString.components(separatedBy: " ")
        nameComponents = nameComponents.map(\.localizedLowercase)
        let biomeIDName = nameComponents.joined(separator: "_")
        guard let biome = MinecraftBiome(biomeIDName, minecraftVersion: MinecraftVersion(mcVersion)) else {
            return nil
        }
        self = biome
    }

    /// Provides a localized string of a biome.
    /// - Parameter version: The Minecraft version relevant to the biome.
    func localizedString(for version: MinecraftVersion) -> String {
        guard let originalID = biome2str(version.versionValue, rawValue) else {
            return String(localized: "unknown_biome")
        }
        let idString = String(cString: originalID)
        var components = idString.components(separatedBy: "_")
        components = components.map(\.localizedCapitalized)
        return components.joined(separator: " ")
    }
}

public extension String {
    /// Initializes a string from a Minecraft biome.
    /// - Parameter biomeID: The Minecraft biome to retrieve the string value of.
    /// - Parameter minecraftVersion: The Minecraft version pertaining to the biome.
    init?(_ biomeID: MinecraftBiome, minecraftVersion: MCVersion) {
        guard let potentialID = biome2str(Int32(minecraftVersion.rawValue), biomeID.rawValue) else {
            return nil
        }
        self.init(cString: potentialID)
    }
}
