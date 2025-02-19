//
//  CartographyMapViewModel.swift
//  MCMaps
//
//  Created by Marquis Kurt on 01-02-2025.
//

import CubiomesKit
import Foundation
import Observation
import SwiftUI

/// A view model for handling various interactions within the app.
@Observable
@MainActor
class CartographyMapViewModel {
    /// The current route the app is handling.
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

    /// The current state of the map being loaded.
    var mapState = CartographyMapViewState.loading

    /// The current search query.
    var searchQuery = ""

    /// The dimension that the map is displaying.
    var worldDimension = MinecraftWorld.Dimension.overworld

    /// The world range that describes the current mapping area.
    var worldRange = MinecraftWorldRange(
        origin: Point3D(x: 0, y: 15, z: 0),
        scale: Point3D(x: 256, y: 1, z: 256))

    /// A string that returns the location of the current world position.
    var positionLabel: String {
        let xPos = String(worldRange.position.x)
        let zPos = String(worldRange.position.z)
        return "X: \(xPos), Z: \(zPos)"
    }

    private var displayRouteInspector = false

    init() {
        self.displayCurrentRouteModally = .init { [weak self] in
            self?.currentRoute?.requiresModalDisplay ?? false
        } set: { [weak self] newValue in
            if !newValue, self?.currentRoute?.requiresModalDisplay ?? false {
                self?.currentRoute = nil
            }
        }
        self.displayCurrentRouteAsInspector = .init { [weak self] in
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

    /// Refresh the current map based on the selected file.
    /// - Parameter file: The file to load the map data from.
    func refreshMap(for file: CartographyMapFile) async {
        mapState = .loading
        do {
            let world = try MinecraftWorld(version: file.map.mcVersion, seed: file.map.seed)
            let mapData = world.snapshot(in: worldRange, dimension: worldDimension)
            mapState = .success(mapData)
        } catch {
            mapState = .unavailable
        }
    }

    /// Jump to a given position, reloading the map in the current process.
    /// - Parameter position: The world position to jump to. The Y coordinate corresponds to the world's Z coordinate.
    /// - Parameter file: The file to load the map data from.
    func go(to position: CGPoint, relativeTo file: CartographyMapFile) {
        worldRange.position = .init(x: Int32(position.x), y: worldRange.position.y, z: Int32(position.y))
        Task { await refreshMap(for: file) }
    }

    @available(*, deprecated, message: "Set the currentRoute to nil.")
    func cancelWorldChanges(_ sizeClass: UserInterfaceSizeClass?) {
        currentRoute = nil
    }

    func submitWorldChanges(to file: CartographyMapFile, _ sizeClass: UserInterfaceSizeClass?) {
        currentRoute = nil
        Task {
            await refreshMap(for: file)
        }
    }

    @available(*, deprecated, message: "Set the currentRoute to .createPin(:)")
    func presentNewPinForm(for location: CGPoint) {
        currentRoute = .createPin(location)
    }
}
