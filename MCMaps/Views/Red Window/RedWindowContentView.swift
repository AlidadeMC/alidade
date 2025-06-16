//
//  CartographyUnifiedView.swift
//  MCMaps
//
//  Created by Marquis Kurt on 14-06-2025.
//

import CubiomesKit
import SwiftUI

/// The new main content view designed for Red Window.
///
/// - Important: This new view is still a working in progress. Not all functionalities are available yet.
/// - SeeAlso: Refer to <doc:RedWindow> for more information on the new Red Window design.
struct RedWindowContentView: View {
    enum RedWindowRoute: Hashable {
        case map
        case gallery
        case allPins
        case pin(MCMapManifestPin)
        case search
    }
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass

    @Binding var file: CartographyMapFile

    @FeatureFlagged(.redWindow) private var useRedWindowDesign

    @State private var currentPosition = CGPoint.zero
    @State private var query = ""
    @State private var renderNaturalColors = true
    @State private var mapDimension = MinecraftWorld.Dimension.overworld
    @State private var tabCustomization = TabViewCustomization()
    @State private var currentTab = RedWindowRoute.map

    var columns: [GridItem] {
        Array(repeating: GridItem(.flexible()), count: horizontalSizeClass == .compact ? 2 : 4)
    }

    var body: some View {
        TabView(selection: $currentTab) {
            Tab("Map", systemImage: "map", value: .map) {
                NavigationStack {
                    worldView
                }
                .toolbar {
                    ToolbarItem {
                        Menu {
                            Toggle(isOn: $renderNaturalColors) {
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
                    LocationBadge(location: currentPosition)
                        .environment(\.contentTransitionAddsDrawingGroup, true)
                        .labelStyle(.titleAndIcon)
                }
            }
            Tab("Gallery", systemImage: "photo.stack", value: .gallery) {
                ContentUnavailableView("No Photos in Gallery", systemImage: "photo.stack")
            }
            Tab(value: .search, role: .search) {
                ContentUnavailableView.search(text: "wtflol")
            }

            TabSection("Library") {
                Tab("All Pins", systemImage: "mappin", value: RedWindowRoute.allPins) {
                    allPinsView
                }
                ForEach(MCMapManifest.preview.pins, id: \.self) { mapPin in
                    Tab(mapPin.name, systemImage: "mappin", value: RedWindowRoute.pin(mapPin)) {
                        NavigationStack {
                            RedWindowPinDetailView(pin: mapPin)
                        }
                    }
                }
            }
            .hidden(horizontalSizeClass == .compact)
        }
        .tabViewStyle(.sidebarAdaptable)
        .tabViewCustomization($tabCustomization)
        .animation(.interactiveSpring, value: currentTab)
    }

    private var worldView: some View {
        Group {
            if let world = try? MinecraftWorld(worldSettings: MCMapManifest.preview.worldSettings) {
                MinecraftMap(world: world, centerCoordinate: $currentPosition, dimension: mapDimension) {
                    MCMapManifest.preview.pins.map { mapPin in
                        Marker(
                            location: mapPin.position,
                            title: mapPin.name,
                            color: mapPin.color?.swiftUIColor ?? .accent
                        )
                    }
                }
                .mapColorScheme(.natural)
            }
        }
        .ignoresSafeArea(.all)
    }

    private var allPinsView: some View {
        NavigationStack {
            ScrollView(.vertical) {
                LazyVGrid(columns: columns) {
                    ForEach(MCMapManifest.preview.pins, id: \.self) { mapPin in
                        NavigationLink {
                            RedWindowPinDetailView(pin: mapPin)
                        } label: {
                            VStack(alignment: .leading) {
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(Color(mapPin.color?.swiftUIColor ?? .accent).gradient)
                                    .frame(height: 100)
                                    .overlay {
                                        Image(systemName: "mappin")
                                            .foregroundStyle(.white)
                                    }
                                Text(mapPin.name)
                                    .font(.headline)
                                    .foregroundStyle(.primary)
                            }
                        }
                        .tint(.primary)
                    }
                    .padding(.horizontal)
                }
            }
            .toolbar {
                ToolbarItem {
                    Button {
                    } label: {
                        Label("Create Pin", systemImage: "mappin.circle")
                    }
                }
            }
        }
        .navigationTitle("All Pins")
    }
}

extension View {
    func backgroundExtensionEffectIfAvailable() -> some View {
        Group {
            if #available(macOS 16, iOS 19, *) {
                self.backgroundExtensionEffect()
            } else {
                self
            }
        }
    }
}
