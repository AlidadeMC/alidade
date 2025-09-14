//
//  CartographyUnifiedView.swift
//  MCMaps
//
//  Created by Marquis Kurt on 14-06-2025.
//

import CubiomesKit
import MCMap
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
    @Environment(\.bluemapService) private var bluemapService
    @Environment(\.documentURL) private var documentURL
    @Environment(\.openWindow) private var openWindow

    /// The file to read from and write to.
    @Binding var file: CartographyMapFile

    @State private var libraryNavigationPath = NavigationPath()

    private var subtitle: String {
        let seed = String(file.manifest.worldSettings.seed)
        return "Minecraft \(file.manifest.worldSettings.version) | Seed: " + seed
    }

    var body: some View {
        @Bindable var env = redWindowEnvironment

        TabView(selection: $env.currentRoute) {
            Tab(route: .map) {
                // NOTE(alicerunsonfedora): This should be completely unnecessary, but for some reason SwiftUI keeps
                // the view around, allowing the map's annotations to be continually reconstructed while other tabs are
                // editing content. This shouldn't be the case, so the map is now only going to display when it's
                // guaranteed that the current route is the map.
                //
                // This should hopefully fix any issues regarding slowdown of editing pin descriptions.
                Group {
                    if env.currentRoute == .map {
                        RedWindowMapView(file: $file)
                    }
                }
            }

            Tab(route: .worldEdit) {
                NavigationStack {
                    MapCreatorForm(
                        worldName: $file.manifest.name,
                        worldSettings: $file.manifest.worldSettings,
                        integrations: $file.integrations,
                        displayMode: .edit
                    )
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
                NavigationStack {
                    CartographyGalleryView(
                        context: CartographyGalleryWindowContext(
                            file: file,
                            documentBaseURL: documentURL
                        )
                    )
                }
            }
            .customizationID("app.tab.gallery")
            .contextMenu {
                Button("Open in New Window", systemImage: "rectangle.badge.plus") {
                    openWindow(
                        id: .gallery,
                        context: CartographyGalleryWindowContext(file: file, documentBaseURL: documentURL)
                    )
                }
            }

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
                ForEach(IndexedPinCollection(file.pins)) { (mapPin: IndexedPinCollection.Element) in
                    Tab(
                        mapPin.content.name,
                        systemImage: mapPin.content.icon?.resolveSFSymbol(in: .pin) ?? "mappin",
                        value: RedWindowRoute.pin(mapPin.content.id)
                    ) {
                        NavigationStack {
                            RedWindowPinDetailView(pin: Binding {
                                return file.pins[mapPin.index]
                            } set: { newValue in
                                file.pins[mapPin.index] = newValue
                            }, file: $file)
                        }
                    }
                    .customizationID("app.tab.library.\(mapPin.content.id.uuidString)")
                    .customizationBehavior(.automatic, for: .automatic)
                    .contextMenu {
                        Button("Go Here", semanticIcon: .goHere) {
                            redWindowEnvironment.mapCenterCoordinate = mapPin.content.position
                        }
                        Button("Copy Coordinates", semanticIcon: .copy) {
                            Task {
                                let pasteboard = PasteboardActor()
                                await pasteboard.copy(mapPin.content.position)
                            }
                        }
                    }
                    .swipeActions {
                        Button("Go Here", semanticIcon: .goHere) {
                            redWindowEnvironment.mapCenterCoordinate = mapPin.content.position
                        }
                    }
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
        .tabViewCustomization($file.appState.tabCustomization)
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
