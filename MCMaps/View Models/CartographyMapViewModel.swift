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
    
    init() {}
    
    func filterPinsByQuery(pins: [CartographyMapPin]) -> [CartographyMapPin] {
        if searchQuery.isEmpty { return pins }
        return pins.filter { pin in
            pin.name.lowercased().contains(searchQuery.lowercased())
        }
    }
    
    func refreshMap(_ seed: Int64, for version: String) async {
        state = .loading
        do {
            let world = try MinecraftWorld(version: version, seed: seed)
            let mapData = world.snapshot(in: worldRange, dimension: worldDimension)
            state = .success(mapData)
        } catch {
            state = .unavailable
        }
        
    }
    
    func goTo(position: CGPoint, seed: Int64, mcVersion: String) {
        worldRange.position = .init(x: Int32(position.x), y: worldRange.position.y, z: Int32(position.y))
        Task { await refreshMap(seed, for: mcVersion) }
    }
    
    func goToRegexPosition(
        _ position: Regex<(Substring, Substring, Substring)>.RegexOutput,
        seed: Int64,
        mcVersion: String,
        completion: @escaping (CGPoint) -> Void
    ) {
        let coordinateX = position.1
        let coordinateY = position.2
        let truePosition = CGPoint(x: Double(coordinateX) ?? 0, y: Double(coordinateY) ?? 0)
        goTo(position: truePosition, seed: seed, mcVersion: mcVersion)
        searchQuery = ""
        completion(truePosition)
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
    
    func submitWorldChanges(seed: Int64, mcVersion: String, _ sizeClass: UserInterfaceSizeClass?) {
        displayChangeSeedForm = false
        Task {
            await refreshMap(seed, for: mcVersion)
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
