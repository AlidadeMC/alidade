//
//  RedWindowRoute.swift
//  MCMaps
//
//  Created by Marquis Kurt on 16-06-2025.
//

import SwiftUI

/// An enumeration representing all the available tab routes in the app.
///
/// This routing system works in conjunction with the new designs via Red Window to provide programmatic navigation.
/// Tabs and navigation links should supply this value to enable routing accordingly.
enum RedWindowRoute: Identifiable, Hashable {
    /// A unique identifier for the current route.
    var id: Self { self }

    /// The main map tab.
    case map

    /// The gallery tab.
    case gallery

    /// The world tab.
    ///
    /// Used to show a form for editing world settings.
    case worldEdit

    /// The "all pins" tab in the Library section.
    ///
    /// This tab only appears under the regular horizontal size class. For compact navigation, use ``allPinsCompact``.
    case allPins

    /// The library tab.
    ///
    /// This tab only appears under the compact horizontal size class. For regular navigation, use ``allPins``.
    case allPinsCompact

    /// A tab showing a specific pin.
    ///
    /// This tab only appears under the regular horizontal size class, where it appears in the sidebar.
    case pin(MCMapManifestPin)

    /// The search tab.
    case search
}

extension RedWindowRoute: CaseIterable {
    static var allCases: [RedWindowRoute] {
        [.map, .worldEdit, .gallery, .search, .allPins]
    }
}

extension RedWindowRoute {
    /// The localized name for the route.
    var name: LocalizedStringKey {
        switch self {
        case .map: "Map"
        case .worldEdit: "World"
        case .gallery: "Gallery"
        case .allPins: "All Pins"
        case .allPinsCompact: "Library"
        case .search: "Search"
        case let .pin(pin): LocalizedStringKey(pin.name)
        }
    }

    /// The symbol representation of the route.
    var symbol: String {
        switch self {
        case .map: "map"
        case .worldEdit: "globe"
        case .gallery: "photo.stack"
        case .allPins: "square.grid.2x2"
        case .allPinsCompact: "books.vertical"
        case .search: "magnifyingglass"
        case .pin: "mappin"
        }
    }
}
