//
//  MCMapManifest.swift
//  MCMaps
//
//  Created by Marquis Kurt on 08-05-2025.
//

import Foundation
import VersionedCodable

/// A typealias that points to the latest manifest version.
///
/// This should be used in conjunction with ``CartographyMapFile`` to ensure that the latest version of the manifest is
/// being used. Whenever encoding to and decoding from this type, use the `encode(versioned:)` and
/// `decode(versioned:data:)` methods from `VersionedCodable`, respectively.
public typealias MCMapManifest = MCMapManifest_v2

extension MCMapManifest {
    /// A typealias that points to a player-created pin.
    public typealias Pin = MCMapManifestPin

    /// A typealias that points to the manifest's world settings.
    public typealias WorldSettings = MCMapManifestWorldSettings
}

/// A protocol that defines a manifest file suitable for a Minecraft map package format.
///
/// Manifests should be backwards-compatible using the `VersionedCodable` system and provide a sample file for use in
/// tests, proxies, and other relevant areas.
protocol MCMapManifestProviding: VersionedCodable where VersionSpec == CartographyMapVersionSpec {
    /// The Minecraft map package world version.
    var manifestVersion: Int? { get set }

    /// The name of the Minecraft world.
    var name: String { get set }

    /// A sample file used for debugging, testing, and preview purposes.
    ///
    /// This might also be used to create a map quickly via a template.
    static var sampleFile: Self { get }
}

/// A structure used to denote the version path in Codable structures.
///
/// This should be used with any manifest files that conform to `VersionedCodable` via the `VersionSpec` typealias.
public struct CartographyMapVersionSpec: VersionPathSpec, Sendable {
    public nonisolated(unsafe) static let keyPathToVersion: KeyPath<CartographyMapVersionSpec, Int?> =
        \Self.manifestVersion

    /// The Minecraft world map package version.
    public var manifestVersion: Int?

    public init(withVersion version: Int?) {
        self.manifestVersion = version
    }
}
