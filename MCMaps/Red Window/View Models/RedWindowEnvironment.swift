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
    /// The app's current route.
    var currentRoute: RedWindowRoute = .map

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
