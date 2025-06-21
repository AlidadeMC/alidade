//
//  RedWindowMapView.swift
//  MCMaps
//
//  Created by Marquis Kurt on 16-06-2025.
//

import CubiomesKit
import SwiftUI

/// The view that is displayed in the Map tab on Red Window.
struct RedWindowMapView: View {
    @Environment(RedWindowEnvironment.self) private var redWindowEnvironment

    /// The file to read from and write to.
    var file: CartographyMapFile

    @AppStorage(UserDefaults.Keys.mapNaturalColors.rawValue)
    private var useNaturalColors = true

    @State private var displayWarpForm = false

    var body: some View {
        @Bindable var env = redWindowEnvironment

        NavigationStack {
            Group {
                if let world = try? MinecraftWorld(worldSettings: file.manifest.worldSettings) {
                    MinecraftMap(
                        world: world,
                        centerCoordinate: $env.mapCenterCoordinate,
                        dimension: env.currentDimension
                    ) {
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
            .sheet(isPresented: $displayWarpForm) {
                NavigationStack {
                    RedWindowMapWarpForm()
                }
            }
            .toolbar {
                ToolbarItem {
                    Menu {
                        Toggle(isOn: $useNaturalColors) {
                            Label("Natural Colors", systemImage: "paintpalette")
                        }
                        WorldDimensionPickerView(selection: $env.currentDimension)
                            .pickerStyle(.inline)
                    } label: {
                        Label("Map", systemImage: "map")
                    }
                }

                #if RED_WINDOW
                    if #available(macOS 16, iOS 19, *) {
                        ToolbarSpacer(.fixed)
                    }
                #endif

                ToolbarItem {
                    Button("Go To", systemImage: "figure.walk") {
                        displayWarpForm.toggle()
                    }
                }
            }
            .overlay(alignment: .bottomTrailing) {
                LocationBadge(location: env.mapCenterCoordinate)
                    .environment(\.contentTransitionAddsDrawingGroup, true)
                    .labelStyle(.titleAndIcon)
            }
        }
    }
}
