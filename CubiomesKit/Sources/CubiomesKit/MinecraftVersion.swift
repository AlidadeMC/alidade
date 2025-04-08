//
//  MinecraftVersion.swift
//  CubiomesKit
//
//  Created by Marquis Kurt on 12-03-2025.
//

import CubiomesInternal
import Foundation

/// An enumeration for all available Minecraft versions.
public typealias MinecraftVersion = MCVersion

extension MinecraftVersion {
    var versionValue: Int32 {
        Int32(rawValue)
    }
}

extension MinecraftVersion {
    /// Initialize a Minecraft version from a string, parsing the results.
    /// - Parameter string: The string content representing the Minecraft version.
    public init(_ string: String) {
        let value = str2mc(string)
        self.init(UInt32(value))
    }

    /// Whether the version is undefined.
    ///
    /// This can occur when the version is a version Cubiomes doesn't support, or if parsing failed.
    public var isUndefined: Bool {
        self == MC_UNDEF
    }
}

extension MinecraftVersion: @retroactive CaseIterable {
    public static var allCases: [MinecraftVersion] {
        return (MC_B1_7.rawValue...MC_NEWEST.rawValue).map {
            MCVersion($0)
        }
    }
}

extension MinecraftVersion: @retroactive Hashable, @retroactive @unchecked Sendable {}

extension String {
    /// Initialize a string from a Minecraft version.
    /// - Parameter mcVersion: The Minecraft version to get a string representation of.
    public init?(_ mcVersion: MinecraftVersion) {
        guard let value = mc2str(mcVersion.versionValue) else {
            return nil
        }
        self.init(cString: value)
    }
}
