//
//  CartographyMapViewModel.swift
//  MCMaps
//
//  Created by Marquis Kurt on 01-02-2025.
//

import AdaptableSidebarSheetView
import CubiomesKit
import Foundation
import Observation
import SwiftUI

/// A view model for handling various interactions within the app.
@Observable
@MainActor
class CartographyMapViewModel {
    /// A enumeration of the cardinal directions.
    enum CardinalDirection {
        case north, south, east, west
    }

    /// The current route the app is handling.
    ///
    /// On iOS and iPadOS, the views handled by route should appear in the adaptable sidebar sheet. On macOS, these
    /// routes will have ``CartographyRoute/requiresModalDisplay`` and
    /// ``CartographyRoute/requiresInspectorDisplay`` properties available to determine whether they should be
    /// displayed as a modal interaction or an inspector pane.
    var currentRoute: CartographyRoute? {
        didSet {
            if currentRoute?.requiresInspectorDisplay == true {
                displayRouteInspector = true
            }
        }
    }

    /// Whether the current route should be displayed as a modal.
    ///
    /// This binding is a mirror of ``CartographyRoute/requiresModalDisplay``.
    var displayCurrentRouteModally: Binding<Bool> = .constant(false)

    /// Whether the current route should be displayed as an inspector.
    ///
    /// This binding is a mirror of ``CartographyRoute/requiresInspectorDisplay``.
    var displayCurrentRouteAsInspector: Binding<Bool> = .constant(false)

    /// Whether the map's colors should correspond to natural colors in the overworld.
    var renderNaturalColors: Bool {
        didSet {
            UserDefaults.standard.set(renderNaturalColors, forKey: .mapNaturalColors)
        }
    }

    /// The current search query.
    var searchQuery = ""

    /// The dimension that the map is displaying.
    var worldDimension = MinecraftWorld.Dimension.overworld

    /// The world range that describes the current mapping area.
    var worldRange = MinecraftWorldRect(
        origin: Point3D(x: 0, y: 15, z: 0),
        scale: MinecraftWorldRect.Size(length: 256, width: 256, height: 1))

    /// A string that returns the location of the current world position.
    var positionLabel: String {
        let xPos = String(worldRange.origin.x)
        let zPos = String(worldRange.origin.z)
        return "X: \(xPos), Z: \(zPos)"
    }

    var displaySidebarSheet = false
    var presentationDetent = AdaptableSidebarSheetBreakpoint.small

    private var displayRouteInspector = false

    init() {
        if !UserDefaults.standard.valueExists(forKey: .mapNaturalColors) {
            UserDefaults.standard.set(true, forKey: .mapNaturalColors)
        }
        self.renderNaturalColors = UserDefaults.standard.bool(forKey: .mapNaturalColors)
        self.displayCurrentRouteModally = Binding { [weak self] in
            self?.currentRoute?.requiresModalDisplay ?? false
        } set: { [weak self] newValue in
            if !newValue, self?.currentRoute?.requiresModalDisplay ?? false {
                self?.currentRoute = nil
            }
        }
        self.displayCurrentRouteAsInspector = Binding { [weak self] in
            guard self?.currentRoute?.requiresInspectorDisplay == true else {
                return false
            }
            return self?.displayRouteInspector ?? false
        } set: { [weak self] newValue in
            guard self?.currentRoute?.requiresInspectorDisplay == true else {
                return
            }
            self?.displayRouteInspector = newValue
        }
    }

    /// Jump to a given position, reloading the map in the current process.
    /// - Parameter position: The world position to jump to. The Y coordinate corresponds to the world's Z coordinate.
    /// - Parameter file: The file to load the map data from.
    func go(to position: CGPoint, relativeTo file: CartographyMapFile) {
        worldRange.origin = Point3D(x: Int32(position.x), y: worldRange.origin.y, z: Int32(position.y))
    }

    /// Submits the player-made changes to the current file and reloads the map.
    /// - Parameter file: The file to commit the changes to.
    func submitWorldChanges(to file: CartographyMapFile) {
        currentRoute = nil
    }
}
