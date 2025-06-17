//
//  RedWindowMapView.swift
//  MCMaps
//
//  Created by Marquis Kurt on 16-06-2025.
//

import CubiomesKit
import SwiftUI

struct RedWindowMapView: View {
    @Binding var file: CartographyMapFile

    @State private var centerCoordinate = CGPoint.zero
    @State private var mapDimension = MinecraftWorld.Dimension.overworld

    @AppStorage(UserDefaults.Keys.mapNaturalColors.rawValue)
    private var useNaturalColors = true

    var body: some View {
        NavigationStack {
            Group {
                if let world = try? MinecraftWorld(worldSettings: file.manifest.worldSettings) {
                    MinecraftMap(world: world, centerCoordinate: $centerCoordinate, dimension: mapDimension) {
                        file.manifest.pins.map { mapPin in
                            Marker(
                                location: mapPin.position,
                                title: mapPin.name,
                                color: mapPin.color?.swiftUIColor ?? .accent
                            )
                        }
                    }
                    .ornaments(.all)
                    .mapColorScheme(.natural)
                }
            }
            .ignoresSafeArea(.all)
            .toolbar {
                ToolbarItem {
                    Menu {
                        Toggle(isOn: $useNaturalColors) {
                            Label("Natural Colors", systemImage: "paintpalette")
                        }
                        WorldDimensionPickerView(selection: $mapDimension)
                            .pickerStyle(.inline)
                    } label: {
                        Label("Map", systemImage: "map")
                    }
                }
            }
            .overlay(alignment: .bottomTrailing) {
                LocationBadge(location: centerCoordinate)
                    .environment(\.contentTransitionAddsDrawingGroup, true)
                    .labelStyle(.titleAndIcon)
            }
        }
    }
}
