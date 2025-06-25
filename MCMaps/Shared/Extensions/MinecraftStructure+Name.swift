//
//  MinecraftStructure+Name.swift
//  MCMaps
//
//  Created by Marquis Kurt on 16-02-2025.
//

import CubiomesKit
import MCMapFormat

extension MinecraftStructure {
    /// The localized name for the given Minecraft structure.
    var name: String {
        switch self {
        case .feature:
            String(localized: "Feature")
        case .desertPyramid:
            String(localized: "Desert Pyramid")
        case .jungleTemple:
            String(localized: "Jungle Temple")
        case .swampHut:
            String(localized: "Swamp Hut")
        case .igloo:
            String(localized: "Igloo")
        case .village:
            String(localized: "Village")
        case .oceanRuin:
            String(localized: "Ocean Ruin")
        case .shipwreck:
            String(localized: "Shipwreck")
        case .monument:
            String(localized: "Monument")
        case .mansion:
            String(localized: "Mansion")
        case .outpost:
            String(localized: "Outpost")
        case .ruinedPortal, .ruinedPortalN:
            String(localized: "Ruined Portal")
        case .ancientCity:
            String(localized: "Ancient City")
        case .treasure:
            String(localized: "Treasure")
        case .mineshaft:
            String(localized: "Mineshaft")
        case .desertWell:
            String(localized: "Desert Well")
        case .geode:
            String(localized: "Geode")
        case .fortress:
            String(localized: "Fortress")
        case .bastion:
            String(localized: "Bastion")
        case .endCity:
            String(localized: "End City")
        case .endGateway:
            String(localized: "End Gateway")
        case .endIsland:
            String(localized: "End Island")
        case .trailRuins:
            String(localized: "Trail Ruins")
        case .trialChambers:
            String(localized: "Trial Chamber")
        }
    }

    /// Creates a structure from a localized string.
    /// - Parameter string: The string to parse and match against.
    init?(string: String) {
        for structure in Self.allCases {
            if structure.name.localizedLowercase == string.localizedLowercase {  // swiftlint:disable:this for_where
                self = structure
                return
            }
        }
        return nil
    }

    /// The pin color associated with the structure.
    ///
    /// This is used in the sidebar to display a unique color based on the structure type.
    var pinColor: MCMapManifestPin.Color {
        switch self {
        case .desertWell, .desertPyramid:
            return .yellow
        case .mineshaft, .village, .mansion, .treasure:
            return .brown
        case .swampHut, .jungleTemple:
            return .green
        case .geode, .endCity, .endIsland, .endGateway:
            return .indigo
        case .bastion, .fortress, .ruinedPortal, .ruinedPortalN:
            return .red
        case .outpost, .feature:
            return .gray
        case .trialChambers, .trailRuins:
            return .orange
        default:
            return .blue
        }
    }
}
