//
//  RedWindowRoute.swift
//  MCMaps
//
//  Created by Marquis Kurt on 16-06-2025.
//

/// An enumeration representing all the available tab routes in the app.
///
/// This routing system works in conjunction with the new designs via Red Window to provide programmatic navigation.
/// Tabs and navigation links should supply this value to enable routing accordingly.
enum RedWindowRoute: Hashable {
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
