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
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass

    @Binding var file: CartographyMapFile

    @FeatureFlagged(.redWindow) private var useRedWindowDesign

    @AppStorage("view.tab_customization") private var tabCustomization = TabViewCustomization()

    @State private var currentTab = RedWindowRoute.map
    @State private var libraryNavigationPath = NavigationPath()

    var body: some View {
        TabView(selection: $currentTab) {
            Tab("Map", systemImage: "map", value: .map) {
                RedWindowMapView(file: $file)
            }

            Tab("World", systemImage: "globe", value: .worldEdit) {
                NavigationStack {
                    MapCreatorForm(worldName: $file.manifest.name, worldSettings: $file.manifest.worldSettings)
                }
            }
            .defaultVisibility(.hidden, for: .tabBar)
            .customizationID("app.tab.world_edit")
            #if os(iOS)
                .customizationBehavior(.automatic, for: .tabBar)
                .customizationBehavior(.disabled, for: .sidebar)
            #endif

            Tab("Library", systemImage: "books.vertical", value: .allPinsCompact) {
                RedWindowPinLibraryView(file: $file, path: $libraryNavigationPath)
            }
            .hidden(horizontalSizeClass != .compact)
            .customizationID("app.tab.library")
            #if os(iOS)
                .customizationBehavior(.disabled, for: .automatic)
            #endif

            Tab("Gallery", systemImage: "photo.stack", value: .gallery) {
                ContentUnavailableView(
                    "Gallery is Empty",
                    systemImage: "photo.stack",
                    description: Text("Photos you add to your pinned places will appear here."))
            }
            .customizationID("app.tab.gallery")

            Tab(value: .search, role: .search) {
                RedWindowSearchView(file: $file)
            }

            TabSection("Library") {
                Tab("All Pins", systemImage: "square.grid.2x2", value: RedWindowRoute.allPins) {
                    RedWindowPinLibraryView(file: $file, path: $libraryNavigationPath)
                }
                .customizationID("app.tab.library.all_pins")
                .tabPlacement(.sidebarOnly)
                #if os(iOS)
                    .customizationBehavior(.disabled, for: .sidebar)
                #endif
                ForEach(file.manifest.pins, id: \.self) { mapPin in
                    Tab(mapPin.name, systemImage: "mappin", value: RedWindowRoute.pin(mapPin)) {
                        NavigationStack {
                            RedWindowPinDetailView(pin: mapPin)
                        }
                    }
                    .customizationID("app.tab.library.\(mapPin.name.snakeCase)")
                    .customizationBehavior(.automatic, for: .automatic)
                }
            }
            .hidden(horizontalSizeClass == .compact)
            #if os(iOS)
                .customizationBehavior(.disabled, for: .sidebar)
            #endif
        }
        .tabViewStyle(.sidebarAdaptable)
        .tabViewCustomization($tabCustomization)
        .animation(.interactiveSpring, value: currentTab)
        .onChange(of: horizontalSizeClass, initial: true) { _, newSizeClass in
            switch (newSizeClass, currentTab) {
            case (.regular, .allPinsCompact):
                currentTab = .allPins
            case (.compact, .allPins):
                currentTab = .allPinsCompact
            default:
                break
            }
        }
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

extension String {
    var snakeCase: String {
        let components = self.components(separatedBy: " ").map(\.localizedLowercase)
        return components.joined(separator: "_")
    }
}
