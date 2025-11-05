//
//  RedWindowEnvironment.swift
//  MCMaps
//
//  Created by Marquis Kurt on 18-06-2025.
//

import CoreGraphics
import CubiomesKit
import Observation

/// A class used to track environment properties for the Red Window redesign.
///
/// This is typically set at the app level and can be accessed via `@Environment(RedWindowEnvironment.self)`.
@Observable
class RedWindowEnvironment {
    // NOTE(marquiskurt): It appears that, under iPadOS 26.1, setting this to the 'map' route causes a breaking issue
    // that prevents players from using the app entirely. It is unclear as to what the cause of this is, since there
    // are no indicators for what could be causing this issue. So, for now, we're setting the default route to the world
    // editor. It's not ideal, but it should unblock the current show-stopper (ALD-29).
    /// The app's current route.
    var currentRoute: RedWindowRoute = .worldEdit

    /// The app's current world dimension.
    ///
    /// This is generally used for the map.
    var currentDimension: MinecraftWorld.Dimension = .overworld

    /// The position that corresponds to the center of the map's view.
    ///
    /// This is generally used to keep track of the map position, and it is used to relay information to search.
    var mapCenterCoordinate = CGPoint.zero

    /// Whether to open the warp form.
    var currentModalRoute: RedWindowModalRoute?
}
