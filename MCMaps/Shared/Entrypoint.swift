//
//  Entrypoint.swift
//  MCMaps
//
//  Created by Marquis Kurt on 31-01-2025.
//

import MCMapFormat
import SwiftUI
import TipKit

/// The main entry point for the Alidade app.
@main
struct MCMapsApp: App {
    @Environment(\.openWindow) private var openWindow
    @Environment(\.openURL) private var openURL

    @AppStorage(UserDefaults.Keys.mapNaturalColors.rawValue) private var naturalColors = true

    @FeatureFlagged(.redWindow) private var useRedWindowDesign

    @State private var displayCreationWindow = false
    @State private var proxyMap = MCMapManifest(
        name: "My World", worldSettings: MCMapManifestWorldSettings(version: "1.21", seed: 0), pins: [])

    @State private var redWindowEnvironment = RedWindowEnvironment()

    init() {
        UserDefaults.standard.set(Self.version, forKey: "CFBundleShortVersionString")
        UserDefaults.standard.set(Self.buildNumber, forKey: "CFBundleVersion")
        UserDefaults.standard.synchronize()
        do {
            try Tips.configure()
        } catch {
            print("Failed to configure tips: \(error.localizedDescription)")
        }
    }

    var body: some Scene {
        DocumentGroup(newDocument: CartographyMapFile(withManifest: .sampleFile)) { configuration in
            Group {
                if useRedWindowDesign {
                    RedWindowContentView(file: configuration.$document)
                        .environment(redWindowEnvironment)
                } else {
                    LegacyContentView(file: configuration.$document)
                        .toolbarRole(.editor)
                        #if os(iOS)
                            .toolbarVisibility(.hidden, for: .navigationBar)
                        #endif
                }
            }
            .environment(
                \.bluemapService,
                CartographyBluemapService(withConfiguration: configuration.document.integrations.bluemap)
            )
        }
        .commands {
            CommandMenu("Map") {
                if useRedWindowDesign {
                    Button("Go To...", systemImage: "figure.walk") {
                        redWindowEnvironment.currentModalRoute = .warpToLocation
                    }
                    .disabled(redWindowEnvironment.currentRoute != .map)
                    .keyboardShortcut("G", modifiers: [.command])
                    Button("Pin Here...", systemImage: "mappin.circle") {
                        redWindowEnvironment.currentModalRoute = .createPin
                    }
                    .disabled(redWindowEnvironment.currentRoute != .map)
                    .keyboardShortcut("P", modifiers: [.command])
                    Divider()
                }
                Toggle(isOn: $naturalColors) {
                    Label("Natural Colors", systemImage: "paintpalette")
                }
                WorldDimensionPickerView(selection: $redWindowEnvironment.currentDimension)
            }
            CommandGroup(replacing: .help) {
                Link("\(Self.appName) Help", destination: URL(appLink: .help)!)
                Divider()
                if let docs = URL(appLink: .docs) {
                    Link("View \(Self.appName) Documentation", destination: docs)
                }
                if let feedback = URL(appLink: .issues) {
                    Link("Send \(Self.appName) Feedback", destination: feedback)
                }
            }
            if useRedWindowDesign {
                CommandGroup(before: .toolbar) {
                    #if os(macOS)
                        let menuItems = RedWindowRoute.allCases.enumerated()
                    #else
                        let menuItems = RedWindowRoute.allCases.enumerated().reversed()
                    #endif
                    ForEach(Array(menuItems), id: \.element.id) { (index, route) in
                        let character = Character("\(index + 1)")

                        Button(route.name, systemImage: route.symbol) {
                            redWindowEnvironment.currentRoute = route
                        }
                        .keyboardShortcut(KeyEquivalent(character), modifiers: .command)
                    }
                }
            }
        }
        #if os(macOS)
            .commands {
                CommandGroup(replacing: .appInfo) {
                    Button("About \(Self.appName)") {
                        openWindow(id: .about)
                    }
                }
                CommandGroup(after: .windowArrangement) {
                    Button("Welcome to \(Self.appName)") {
                        openWindow(id: .launch)
                    }
                    .keyboardShortcut("0", modifiers: [.shift, .command])
                }
            }
        #endif
        #if DEBUG
            .commands {
                CommandMenu("Debug") {
                    Menu("Tips") {
                        Button("Show All Tips") {
                            Tips.showAllTipsForTesting()
                        }
                        Button("Hide All Tips") {
                            Tips.hideAllTipsForTesting()
                        }
                        Button("Reset Tip Datastore") {
                            do {
                                try Tips.resetDatastore()
                            } catch {
                                print("Failed to reset datastore: \(error.localizedDescription)")
                            }
                        }
                    }
                }
            }
        #endif

        DocumentLaunchView(
            viewModel: DocumentLaunchViewModel(displayCreationWindow: $displayCreationWindow, proxyMap: $proxyMap)
        )

        #if os(macOS)
            Window("About \(Self.appName)", id: "about") {
                AboutWindowView()
                    .containerBackground(.thickMaterial, for: .window)
            }
            .windowStyle(.hiddenTitleBar)
            .windowResizability(.contentSize)
            .windowToolbarStyle(.unified)
            .windowBackgroundDragBehavior(.enabled)

            Settings {
                AlidadeSettingsView()
                    .presentedWindowToolbarStyle(.unifiedCompact)
            }
        #endif

        WindowGroup(id: WindowID.gallery.rawValue, for: CartographyGalleryWindowContext.self) { galleryCtx in
            NavigationStack {
                CartographyGalleryView(context: galleryCtx.wrappedValue ?? .empty())
            }
            #if os(iOS)
                .toolbarRole(.browser)
            #endif
        }
    }
}

#if DEBUG
    extension MCMapsApp {
        var testHooks: TestHooks { TestHooks(target: self) }

        @MainActor
        struct TestHooks {
            private let target: MCMapsApp

            fileprivate init(target: MCMapsApp) {
                self.target = target
            }

            var displayCreationWindow: Bool {
                target.displayCreationWindow
            }

            var proxyMap: MCMapManifest {
                target.proxyMap
            }
        }
    }
#endif
