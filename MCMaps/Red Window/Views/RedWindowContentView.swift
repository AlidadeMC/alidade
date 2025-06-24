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
/// The new design sports a universal tab bar that adapts to a sidebar on iPadOS and macOS. On iPadOS, players can
/// rearrange and customize the tab bar to their liking.
///
/// The map, world settings, and gallery views are put into their own respective tabs. Search is broken out into its
/// own tab, and the player-created pins are put into new areas via the Library tab.
///
/// - Important: This new view is still a working in progress. Not all functionalities are available yet.
/// - SeeAlso: Refer to <doc:RedWindow> for more information on the new Red Window design.
struct RedWindowContentView: View {
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    @Environment(RedWindowEnvironment.self) private var redWindowEnvironment

    /// The file to read from and write to.
    @Binding var file: CartographyMapFile

    @FeatureFlagged(.redWindow) private var useRedWindowDesign

    @AppStorage("view.tab_customization") private var tabCustomization = TabViewCustomization()

    @State private var libraryNavigationPath = NavigationPath()

    private var subtitle: String {
        let seed = String(file.manifest.worldSettings.seed)
        return "Minecraft \(file.manifest.worldSettings.version) | Seed: " + seed
    }

    var body: some View {
        @Bindable var env = redWindowEnvironment

        TabView(selection: $env.currentRoute) {
            Tab(route: .map) {
                RedWindowMapView(file: $file)
            }

            Tab(route: .worldEdit) {
                NavigationStack {
                    MapCreatorForm(worldName: $file.manifest.name, worldSettings: $file.manifest.worldSettings)
                    #if os(macOS)
                        .formStyle(.grouped)
                    #endif
                }
            }
            .defaultVisibility(.hidden, for: .tabBar)
            .customizationID("app.tab.world_edit")
            #if os(iOS)
                .customizationBehavior(.automatic, for: .tabBar)
                .customizationBehavior(.disabled, for: .sidebar)
            #endif

            Tab(route: .allPinsCompact) {
                RedWindowPinLibraryView(file: $file, path: $libraryNavigationPath)
            }
            .hidden(horizontalSizeClass != .compact)
            .customizationID("app.tab.library")
            #if os(iOS)
                .customizationBehavior(.disabled, for: .automatic)
            #endif

            Tab(route: .gallery) {
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
                Tab(route: .allPins) {
                    RedWindowPinLibraryView(file: $file, path: $libraryNavigationPath)
                }
                .customizationID("app.tab.library.all_pins")
                .tabPlacement(.sidebarOnly)
                #if os(iOS)
                    .customizationBehavior(.disabled, for: .sidebar)
                #endif
                ForEach(IndexedPinCollection(file.manifest.pins)) { (mapPin: IndexedPinCollection.Element) in
                    Tab(
                        mapPin.content.name,
                        systemImage: "mappin",
                        value: RedWindowRoute.pin(mapPin.content)
                    ) {
                        NavigationStack {
                            RedWindowPinDetailView(pin: Binding {
                                return file.manifest.pins[mapPin.index]
                            } set: { newValue in
                                file.manifest.pins[mapPin.index] = newValue
                            }, file: $file)
                        }
                    }
                    .customizationID("app.tab.library.\(mapPin.content.name.snakeCase)")
                    .customizationBehavior(.automatic, for: .automatic)
                }
            }
            .hidden(horizontalSizeClass == .compact)
            #if os(iOS)
                .customizationBehavior(.disabled, for: .sidebar)
            #endif
        }
        #if os(macOS)
        .navigationSubtitle(subtitle)
        #endif
        .tabViewStyle(.sidebarAdaptable)
        .tabViewCustomization($tabCustomization)
        .animation(.interactiveSpring, value: env.currentRoute)
        .onChange(of: horizontalSizeClass, initial: true) { _, newSizeClass in
            switch (newSizeClass, env.currentRoute) {
            case (.regular, .allPinsCompact):
                env.currentRoute = .allPins
            case (.compact, .allPins):
                env.currentRoute = .allPinsCompact
            default:
                break
            }
        }
    }
}
