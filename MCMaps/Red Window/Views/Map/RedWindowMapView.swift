//
//  RedWindowMapView.swift
//  MCMaps
//
//  Created by Marquis Kurt on 16-06-2025.
//

import AlidadeUI
import Combine
import CubiomesKit
import MCMapFormat
import SwiftUI
import os

private let logger = Logger(subsystem: "net.marquiskurt.mcmaps", category: "map.red_window")

/// The view that is displayed in the Map tab on Red Window.
struct RedWindowMapView: View {
    @Environment(\.bluemapService) private var bluemapService
    @Environment(RedWindowEnvironment.self) private var redWindowEnvironment

    /// The file to read from and write to.
    @Binding var file: CartographyMapFile

    @AppStorage(UserDefaults.Keys.mapNaturalColors.rawValue)
    private var useNaturalColors = true

    @State private var applesauce = BluemapResults()
    @State private var displayWarpForm = false
    @State private var displayPinForm = false
    @State private var integrationFetchState = IntegrationFetchState.initial

    private let bmapTimer: Publishers.Autoconnect<Timer.TimerPublisher>

    private var bmapMarkers: [CubiomesKit.Marker] {
        guard file.integrations.bluemap.enabled else {
            return []
        }

        guard var poiMap = applesauce.markers else { return [] }
        if !file.integrations.bluemap.displayOptions.contains(.deathMarkers) {
            poiMap["death-markers"] = nil
        }

        return poiMap.flatMap { (key, group) in
            if key == "death-markers" {
                return group.markers.values.map { annotation in
                    Marker(
                        location: CGPoint(x: annotation.position.x, y: annotation.position.z),
                        title: annotation.label,
                        color: .gray,
                        systemImage: "xmark.circle")
                }
            }
            return group.markers.values.map { annotation in
                Marker(
                    location: CGPoint(x: annotation.position.x, y: annotation.position.z),
                    title: annotation.label)
            }
        }
    }

    private var bmapPlayers: [CubiomesKit.PlayerMarker] {
        guard file.integrations.bluemap.enabled, let players = applesauce.players else {
            return []
        }
        return players.players.map { player in
            PlayerMarker(
                location: CGPoint(x: player.position.x, y: player.position.z),
                name: player.name,
                playerUUID: player.uuid)
        }
    }

    init(file: Binding<CartographyMapFile>) {
        self._file = file
        let bmap = file.wrappedValue.integrations.bluemap
        self.bmapTimer = Timer.publish(every: bmap.refreshRate, on: .main, in: .common).autoconnect()
    }

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
                        bmapMarkers
                        bmapPlayers
                    }
                    .ornaments(.all)
                    .mapColorScheme(useNaturalColors ? .natural : .default)
                }
            }
            .ignoresSafeArea(.all)
            .animation(.interactiveSpring, value: integrationFetchState)
            .task {
                await updateIntegrationData()
            }
            .onReceive(bmapTimer) { _ in
                Task { await updateIntegrationData() }
            }
            .onChange(of: env.currentDimension, initial: false) { _, _ in
                Task { await updateIntegrationData() }
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
                        file.manifest.pins.append(newPin)
                    }
                    #if os(macOS)
                        .formStyle(.grouped)
                    #endif
                }
            }
            .toolbar {
                ToolbarItem {
                    if file.integrations.bluemap.enabled {
                        Button("Sync From Integrations", systemImage: "arrow.clockwise") {
                            Task { await updateIntegrationData() }
                        }
                    }
                }
                #if RED_WINDOW
                    if #available(macOS 16, iOS 19, *) {
                        ToolbarSpacer(.fixed)
                    }
                #endif

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
                ToolbarItem {
                    Button("Pin Here...", systemImage: "mappin.circle") {
                        displayPinForm.toggle()
                    }
                }
            }
            .overlay(alignment: .bottomTrailing) {
                LocationBadge(location: env.mapCenterCoordinate)
                    .environment(\.contentTransitionAddsDrawingGroup, true)
                    .labelStyle(.titleAndIcon)
            }
            .overlay(alignment: .bottomLeading) {
                IntegrationFetchStateView(state: integrationFetchState)
                    .padding(8)
            }
        }
    }

    private func updateIntegrationData() async {
        guard file.supportedFeatures.contains(.integrations), file.integrations.enabled else {
            withAnimation {
                integrationFetchState = .cancelled
            }
            logger.info("Integrations are not supported. Skipping this update cycle.")
            return
        }

        withAnimation {
            integrationFetchState = .refreshing
        }
        logger.debug("Starting update cycle.")

        let dimension = redWindowEnvironment.currentDimension
        let response = await withTaskGroup(of: BluemapResults.self, returning: BluemapResults.self) { taskGroup in
            if !file.integrations.bluemap.displayOptions.isDisjoint(with: [.deathMarkers, .markers]) {
                taskGroup.addTask {
                    await fetchMarkers(dimension: dimension)
                }
            }
            if file.integrations.bluemap.displayOptions.contains(.players) {
                taskGroup.addTask {
                    await fetchPlayers(dimension: dimension)
                }
            }

            var finalResult = BluemapResults()
            for await result in taskGroup {
                finalResult = finalResult.merged(with: result)
            }
            return finalResult
        }

        if response.isNone {
            logger.info("Response received back is bad.")
            withAnimation {
                integrationFetchState = .error("Bad response")
            }
            return
        }

        logger.debug("Setting up from new response.")
        self.applesauce = response
        withAnimation {
            integrationFetchState = .success(.now)
        }
    }

    private func fetchMarkers(dimension: MinecraftWorld.Dimension) async -> BluemapResults {
        do {
            let data: [String: BluemapMarkerAnnotationGroup]? = try await bluemapService?.fetch(
                endpoint: .markers,
                for: dimension
            )
            return BluemapResults(markers: data)
        } catch {
            logger.error("Failed to fetch POIs: \(error.localizedDescription)")
            return BluemapResults()
        }
    }

    private func fetchPlayers(dimension: MinecraftWorld.Dimension) async -> BluemapResults {
        do {
            let data: BluemapPlayerResponse? = try await bluemapService?.fetch(
                endpoint: .players,
                for: dimension
            )
            return BluemapResults(players: data)
        } catch {
            logger.error("Failed to fetch players: \(error.localizedDescription)")
            return BluemapResults()
        }
    }
}
