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
    private typealias IntegrationServiceType = CartographyIntegrationService.ServiceType

    @Environment(\.bluemapService) private var bluemapService
    @Environment(RedWindowEnvironment.self) private var redWindowEnvironment

    /// The file to read from and write to.
    @Binding var file: CartographyMapFile

    @AppStorage(UserDefaults.Keys.mapNaturalColors.rawValue)
    private var useNaturalColors = true

    @State private var displayWarpForm = false
    @State private var displayPinForm = false
    @State private var integrationFetchState = IntegrationFetchState.initial
    @State private var integrationData = [IntegrationServiceType: any CartographyIntegrationServiceData]()

    private var integrationAnnotations: [any MinecraftMapBuilderContent] {
        var annotations = [any MinecraftMapBuilderContent]()
        for (key, value) in integrationData {
            switch key {
            case .bluemap:
                if let data = value as? BluemapResults {
                    annotations.append(contentsOf: data.annotations(from: file.integrations.bluemap))
                }
            }
        }
        return annotations
    }

    private let bmapTimer: Publishers.Autoconnect<Timer.TimerPublisher>

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
                        integrationAnnotations
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
        let service = CartographyIntegrationService(serviceType: .bluemap, integrationSettings: file.integrations)
        do {
            withAnimation { integrationFetchState = .refreshing }
            let result: BluemapResults? = try await service.sync(dimension: redWindowEnvironment.currentDimension)
            guard let result else {
                withAnimation { integrationFetchState = .error("Response returned empty.") }
                return
            }
            integrationData[.bluemap] = result
            withAnimation { integrationFetchState = .success(.now) }
        } catch CartographyIntegrationService.ServiceError.integrationDisabled {
            withAnimation {
                integrationFetchState = .cancelled
            }
        } catch {
            withAnimation {
                integrationFetchState = .error(error.localizedDescription)
            }
        }
    }
}
