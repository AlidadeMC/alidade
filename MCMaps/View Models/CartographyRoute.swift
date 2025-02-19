//
//  CartographySidebarSelection.swift
//  MCMaps
//
//  Created by Marquis Kurt on 19-02-2025.
//

import Foundation

/// An enumeration representing the routes available within the app.
enum CartographyRoute: Equatable, Hashable, Identifiable {
    /// A unique identifier for the current route.
    var id: UUID { UUID() }

    /// A user-pinned location at a specified index in the file.
    case pin(Int, pin: CartographyMapPin)

    /// A location the user has visited before.
    case recent(CGPoint)

    /// The user is requesting to create a pin from a location.
    case createPin(CGPoint)

    /// The user is requesting to make changes to the world.
    case editWorld

    /// Whether the route should be displayed as a modal instead of a navigation stack item.
    ///
    /// On iOS and iPadOS, this will always return `false`.
    var requiresModalDisplay: Bool {
        #if os(macOS)
            switch self {
            case .recent, .pin:
                return false
            default:
                return true
            }
        #else
            return false
        #endif
    }

    /// Whether the route should be displayed as an inspector pane instead of a navigation stack item.
    ///
    /// On iOS and iPadOS, this will always return `false`.
    var requiresInspectorDisplay: Bool {
        #if os(macOS)
            switch self {
            case .pin:
                return true
            default:
                return false
            }
        #else
            return false
        #endif
    }
}
