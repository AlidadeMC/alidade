//
//  RedWindowMapView.swift
//  MCMaps
//
//  Created by Marquis Kurt on 16-06-2025.
//

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

    @State private var displayWarpForm = false
    @State private var displayPinForm = false
    @State private var integrationFetchState = IntegrationFetchState.initial

    @State private var bmapCommonPOIs: [String: BluemapMarkerAnnotationGroup]?

    private let bmapTimer: Publishers.Autoconnect<Timer.TimerPublisher>

    private var bmapMarkers: [CubiomesKit.Marker] {
        guard file.integrations.bluemap.enabled, file.integrations.bluemap.display.displayMarkers else {
            return []
        }

        guard let pois = bmapCommonPOIs?.values else { return [] }
        return pois.flatMap { group in
            group.markers.values.map { annotation in
                Marker(location: CGPoint(x: annotation.position.x, y: annotation.position.z), title: annotation.label)
            }
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
                    }
                    .ornaments(.all)
                    .mapColorScheme(.natural)
                }
            }
            .ignoresSafeArea(.all)
            .animation(.interactiveSpring, value: integrationFetchState)
            .onAppear {
                updateIntegrationData()
            }
            .onReceive(bmapTimer) { _ in
                updateIntegrationData()
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

    private func updateIntegrationData() {
        guard file.supportedFeatures.contains(.integrations), file.integrations.bluemap.enabled else {
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

        Task {
            do {
                bmapCommonPOIs = try await bluemapService?
                    .fetch(endpoint: .markers, for: redWindowEnvironment.currentDimension)
                let keys = bmapCommonPOIs?.keys.joined(separator: ",") ?? "none"
                logger.debug("New data fetched: \(keys)")
                withAnimation {
                    integrationFetchState = .success(.now)
                }
            } catch {
                logger.error("Failed to get map markers: \(error)")
                withAnimation {
                    integrationFetchState = .error(error.localizedDescription)
                }
            }
        }
    }
}
