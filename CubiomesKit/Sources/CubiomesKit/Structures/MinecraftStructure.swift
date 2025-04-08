//
//  MinecraftStructure.swift
//  CubiomesKit
//
//  Created by Marquis Kurt on 16-02-2025.
//

import CubiomesInternal
import Foundation

/// An enumeration of all the Minecraft structures.
public enum MinecraftStructure: Equatable, Sendable, CaseIterable {
    case feature
    case desertPyramid
    case jungleTemple
    case swampHut
    case igloo
    case village
    case oceanRuin
    case shipwreck
    case monument
    case mansion
    case outpost
    case ruinedPortal, ruinedPortalN
    case ancientCity
    case treasure
    case mineshaft
    case desertWell
    case geode
    case fortress
    case bastion
    case endCity
    case endGateway
    case endIsland
    case trailRuins
    case trialChambers

    /// The Cubiomes variant of the structure.
    ///
    /// This is used to handle internal Cubiomes functions and isn't generally useful on its own.
    public var cbStructure: StructureType {
        return switch self {
        case .feature:
            Feature
        case .desertPyramid:
            Desert_Pyramid
        case .jungleTemple:
            Jungle_Temple
        case .swampHut:
            Swamp_Hut
        case .igloo:
            Igloo
        case .village:
            Village
        case .oceanRuin:
            Ocean_Ruin
        case .shipwreck:
            Shipwreck
        case .monument:
            Monument
        case .mansion:
            Mansion
        case .outpost:
            Outpost
        case .ruinedPortal:
            Ruined_Portal
        case .ruinedPortalN:
            Ruined_Portal_N
        case .ancientCity:
            Ancient_City
        case .treasure:
            Treasure
        case .mineshaft:
            Mineshaft
        case .desertWell:
            Desert_Well
        case .geode:
            Geode
        case .fortress:
            Fortress
        case .bastion:
            Bastion
        case .endCity:
            End_City
        case .endGateway:
            End_Gateway
        case .endIsland:
            End_Island
        case .trailRuins:
            Trail_Ruins
        case .trialChambers:
            Trial_Chambers
        }
    }
}
