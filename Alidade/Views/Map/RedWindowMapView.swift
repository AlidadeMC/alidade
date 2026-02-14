//
//  RedWindowMapView.swift
//  MCMaps
//
//  Created by Marquis Kurt on 16-06-2025.
//

import AlidadeUI
import CubiomesKit
import FeatureFlags
import MCMap
import SwiftUI
import os

private let logger = Logger(subsystem: "net.marquiskurt.mcmaps", category: "\(RedWindowMapView.self)")

/// A view that displays a map of the current Minecraft world.
///
/// Much like the original map view, this map view allows players to navigate around their world in a map view using
/// MapKit. Depending on whether the integration is enabled, markers from Bluemap are also displayed in this view. A
/// timer is automatically created at initialization to periodically refresh the data at the time that the player
/// requests.
///
/// Players can also quickly switch between dimensions, jump to locations, and create a pin.
struct RedWindowMapView: View {
    private typealias IntegrationServiceType = CartographyIntegrationService.ServiceType

    @Environment(RedWindowEnvironment.self) private var redWindowEnvironment

    @FeatureFlagged(.drawings) private var allowMapDrawings

    /// The file containing the information about the world, integrations, etc.
    @Binding var file: CartographyMapFile

    @AppStorage(UserDefaults.Keys.mapNaturalColors.rawValue)
    private var useNaturalColors = true

    @State private var displayWarpForm = false
    @State private var displayPinForm = false
    @State private var integrationState = IntegrationFetchState.initial
    @State private var isDrawingOnMap = false

    var body: some View {
        @Bindable var env = redWindowEnvironment

        ManagedAnnotatedMap(file: file, dimension: redWindowEnvironment.currentDimension) { state, annotations in
            NavigationStack {
                Group {
                    if let world = try? MinecraftWorld(worldSettings: file.manifest.worldSettings) {
                        MinecraftMap(
                            world: world,
                            centerCoordinate: $env.mapCenterCoordinate,
                            dimension: env.currentDimension
                        ) {
                            annotations
                        }
                        .ornaments(.all)
                        .mapColorScheme(useNaturalColors ? .natural : .default)
                        #if os(iOS)
                            .allowsPencilKitDrawings(allowMapDrawings)
                            .activateDrawingCanvas(isDrawing: $isDrawingOnMap)
                            .addedMapDrawing(storeDrawing(_:))
                        #endif
                    }
                }
                #if os(macOS)
                    .toolbarBackgroundVisibility(.hidden, for: .windowToolbar)
                #endif
                .animation(.interactiveSpring, value: state)
                .ignoresSafeArea(.all)
                .overlay(alignment: .bottomLeading) {
                    IntegrationFetchStateView(state: state)
                        .padding(8)
                        .opacity(file.integrations.enabled ? 1 : 0)
                        #if os(macOS)
                            .padding(.bottom, 4)
                        #endif
                }
                .overlay(alignment: .bottomTrailing) {
                    LocationBadge(location: env.mapCenterCoordinate)
                        .environment(\.contentTransitionAddsDrawingGroup, true)
                        .labelStyle(.titleAndIcon)
                        #if os(macOS)
                            .padding(.bottom, 4)
                            // NOTE(alicerunsonfedora): This applies the zoom control's width (36) with some extra
                            // padding, but it's unclear how this will change over time, let alone whether this is the
                            // right way to offset the badge to prevent obstructions (see ALD-20).
                            .padding(.trailing, 48)
                        #endif
                }
                .onChange(of: env.currentModalRoute, initial: false) { _, newValue in
                    guard let newValue else { return }
                    switch newValue {
                    case .warpToLocation:
                        displayWarpForm = true
                    case .createPin:
                        displayPinForm = true
                    }
                }
                .onChange(of: displayWarpForm, initial: false) { _, newValue in
                    if !newValue, env.currentModalRoute != nil {
                        env.currentModalRoute = nil
                    }
                }
                .onChange(of: displayPinForm, initial: false) { _, newValue in
                    if !newValue, env.currentModalRoute != nil {
                        env.currentModalRoute = nil
                    }
                }
                .sheet(isPresented: $displayWarpForm) {
                    NavigationStack {
                        RedWindowMapWarpForm()
                    }
                }
                .sheet(isPresented: $displayPinForm) {
                    NavigationStack {
                        PinCreatorForm(location: env.mapCenterCoordinate.rounded()) { newPin in
                            file.pins.append(newPin)
                        }
                        #if os(macOS)
                            .formStyle(.grouped)
                        #endif
                    }
                }
                .toolbar { toolbar(env) }
            }
        }
    }

    private func storeDrawing(_ drawing: MinecraftMapDrawing) {
        guard file.supportedFeatures.contains(.drawings) else {
            return
        }
        let mapCoordinate = CGPoint(projectedFrom: drawing.location)
        let rect = CartographyDrawing.DrawingOverlay.MapRect(
            x: Int(mapCoordinate.x),
            z: Int(mapCoordinate.y),
            width: Int(drawing.mapRect.width),
            height: Int(drawing.mapRect.height)
        )
        let storedDrawing = CartographyDrawing(
            data: CartographyDrawing.DrawingOverlay(
                coordinate: mapCoordinate,
                drawing: drawing.drawing,
                mapRect: rect
            )
        )
        file.drawings.append(storedDrawing)
    }

    private func toolbar(_ environment: RedWindowEnvironment) -> some ToolbarContent {
        @Bindable var env = environment
        return Group {
            ToolbarItem {
                Menu("Map", systemImage: "map") {
                    #if os(iOS)
                        Label("Map", systemImage: "map")
                            .foregroundStyle(.secondary)
                    #endif
                    Divider()
                    Toggle(isOn: $useNaturalColors) {
                        Label("Natural Colors", systemImage: "paintpalette")
                    }
                    WorldDimensionPickerView(selection: $env.currentDimension)
                        .pickerStyle(.inline)
                        .labelsVisibility(.visible)
                }
            }

            ToolbarSpacer(.fixed)

            ToolbarItem {
                Button("Go To", systemImage: "figure.walk") {
                    displayWarpForm.toggle()
                }
            }
            #if os(iOS)
                if allowMapDrawings, !isDrawingOnMap {
                    ToolbarSpacer(.fixed)
                }
            #endif
            ToolbarItem {
                Button("Pin Here...", systemImage: "mappin.circle") {
                    displayPinForm.toggle()
                }
            }
            #if os(iOS)
                if allowMapDrawings {
                    ToolbarItem {
                        Button(
                            "Draw",
                            systemImage: isDrawingOnMap ? "checkmark" : "pencil.and.outline",
                            role: isDrawingOnMap ? .confirm : .close
                        ) {
                            withAnimation {
                                isDrawingOnMap.toggle()
                            }
                        }
                    }
                }
            #endif
        }
    }
}
