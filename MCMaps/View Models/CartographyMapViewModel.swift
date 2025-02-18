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

@Observable
@MainActor
class CartographyMapViewModel {
    #if os(iOS)
        var displaySidebarSheet = false
    #endif
    var displayChangeSeedForm = false
    var displayNewPinForm = false
    var displayPinInformation = false

    var state = CartographyMapViewState.loading
    var searchQuery = ""
    var worldDimension = MinecraftWorld.Dimension.overworld
    var worldRange = MinecraftWorldRange(
        origin: Point3D(x: 0, y: 15, z: 0),
        scale: Point3D(x: 256, y: 1, z: 256))

    var positionLabel: String {
        let xPos = String(worldRange.position.x)
        let zPos = String(worldRange.position.z)
        return "X: \(xPos), Z: \(zPos)"
    }

    var locationToPin: CGPoint = .zero
    var selectedPinIndex = -1

    init() {}

    func refreshMap(for file: CartographyMapFile) async {
        state = .loading
        do {
            let world = try MinecraftWorld(version: file.map.mcVersion, seed: file.map.seed)
            let mapData = world.snapshot(in: worldRange, dimension: worldDimension)
            state = .success(mapData)
        } catch {
            state = .unavailable
        }
    }

    func go(to position: CGPoint, relativeTo file: CartographyMapFile) {
        worldRange.position = .init(x: Int32(position.x), y: worldRange.position.y, z: Int32(position.y))
        Task { await refreshMap(for: file) }
    }

    func presentWorldChangesForm() {
        #if os(iOS)
            displaySidebarSheet = false
        #endif
        displayChangeSeedForm = true
    }

    func cancelWorldChanges(_ sizeClass: UserInterfaceSizeClass?) {
        displayChangeSeedForm = false
        #if os(iOS)
            displaySidebarSheet = sizeClass == .compact
        #endif
    }

    func submitWorldChanges(to file: CartographyMapFile, _ sizeClass: UserInterfaceSizeClass?) {
        displayChangeSeedForm = false
        Task {
            await refreshMap(for: file)
        }
        #if os(iOS)
            displaySidebarSheet = sizeClass == .compact
        #endif
    }

    func presentNewPinForm(for location: CGPoint) {
        #if os(iOS)
            displaySidebarSheet = false
        #endif
        displayNewPinForm = true
        locationToPin = location
    }
}
