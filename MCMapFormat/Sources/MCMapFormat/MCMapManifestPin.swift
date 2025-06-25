//
//  Pin.swift
//  MCMaps
//
//  Created by Marquis Kurt on 03-02-2025.
//

import SwiftUI

/// A representation of a player-placed map pin.
public struct MCMapManifestPin: Codable, Hashable, Sendable {
    /// An enumeration representing the various colors a player can assign a pin to.
    ///
    /// When being encoded to and decoded from, they are represented as strings. For example, ``blue`` corresponds to
    /// `"blue"`.
    public enum Color: String, Codable, Hashable, CaseIterable, Sendable {
        case red, orange, yellow, green, blue, indigo, brown, gray, pink
    }

    /// The pin's world location.
    ///
    /// The X and Y coordinates correspond to the X and Z world coordinates, respectively.
    public var position: CGPoint

    /// The pin's assigned name.
    public var name: String

    /// The pin's color.
    ///
    /// Defaults to ``Color-swift.enum/blue`` if none was provided.
    public var color: Color? = .blue

    /// The image files that are associated with this pin.
    ///
    /// Images consist of player-uploaded screenshots and are located in the ``CartographyMapFile/Keys/images``
    /// directory.
    public var images: [String]? = []

    /// A player-written note that describes this pin.
    ///
    /// This is typically used to describe player-provided information such as the pin's significance, notable areas of
    /// interest, and what is nearby.
    public var aboutDescription: String? = ""

    /// A list of tags the player has assigned.
    ///
    /// > Note: This is only available in v2 of the manifest or later.
    public var tags: Set<String>? = []

    public init(
        position: CGPoint,
        name: String,
        color: Color? = nil,
        images: [String]? = nil,
        aboutDescription: String? = nil,
        tags: Set<String>? = nil
    ) {
        self.position = position
        self.name = name
        self.color = color
        self.images = images
        self.aboutDescription = aboutDescription
        self.tags = tags
    }
}

extension MCMapManifestPin: Identifiable {
    public var id: Self { self }
}
