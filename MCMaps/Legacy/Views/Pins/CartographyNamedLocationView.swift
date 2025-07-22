//
//  CartographyNamedLocationView.swift
//  MCMaps
//
//  Created by Marquis Kurt on 08-02-2025.
//

import AlidadeUI
import MCMap
import SwiftUI

extension NamedLocationView {
    /// Create a named location view using a player-created pin.
    /// - Parameter pin: The pin to create a named location view from.
    init(pin: CartographyMapPin) {
        let systemImage =
            switch pin.icon {
            case .default, nil, .emoji:
                "mappin"
            default:
                pin.icon?.rawValue
            }

        self.init(
            name: pin.name,
            location: pin.position,
            systemImage: systemImage ?? "mappin",
            color: pin.color?.swiftUIColor ?? .accent
        )
    }

}

/// A view that displays a location with a specified name.
///
/// Named location views are commonly used to display locations that have an associated name, such as a player-created
/// pin or a search result for a structure. Named locations can also specify a color and display mode that changes how
/// the coordinate is displayed on screen.
@available(*, deprecated, message: "Use NamedLocationView from AlidadeUI.")
typealias CartographyNamedLocationView = NamedLocationView
