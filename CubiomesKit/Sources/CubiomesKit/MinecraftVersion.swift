//
//  MinecraftVersion.swift
//  CubiomesKit
//
//  Created by Marquis Kurt on 12-03-2025.
//

import CubiomesInternal
import Foundation

/// An enumeration for all available Minecraft versions.
///
/// Due to limitations with the way this enum is imported in Cubiomes, all of their cases are separate. They are
/// prefixed with `MC_`.
public typealias MinecraftVersion = MCVersion

extension MinecraftVersion {
    var versionValue: Int32 {
        Int32(rawValue)
    }
}

public extension MinecraftVersion {
    init(_ string: String) {
        let value = str2mc(string)
        self.init(UInt32(value))
    }

    var isUndefined: Bool {
        self == MC_UNDEF
    }
}

extension MinecraftVersion: @retroactive CaseIterable {
    public static var allCases: [MinecraftVersion] {
        return (MC_UNDEF.rawValue...MC_NEWEST.rawValue).map {
            MCVersion($0)
        }
    }
}

extension MinecraftVersion: @retroactive Hashable, @retroactive @unchecked Sendable {}

public extension String {
    init?(_ mcVersion: MinecraftVersion) {
        guard let value = mc2str(mcVersion.versionValue) else {
            return nil
        }
        self.init(cString: value)
    }
}
