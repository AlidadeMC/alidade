//
//  Entrypoint.swift
//  MCMaps
//
//  Created by Marquis Kurt on 31-01-2025.
//

import AlidadeUI
import DocumentKitSwiftUI
import MCMap
import SwiftUI
import TipKit

typealias DocumentContinuation = CheckedContinuation<CartographyMapFile, any Error>

/// The main entry point for the Alidade app.
@main
struct MCMapsApp: App {
    @Environment(\.scenePhase) private var scenePhase
    @Environment(\.openWindow) private var openWindow
    @Environment(\.openURL) private var openURL

    @AppStorage(UserDefaults.Keys.mapNaturalColors.rawValue) private var naturalColors = true

    @State private var clock = CartographyClock()
    @State private var displayCreationWindow = false
    @State private var proxyMap = MCMapManifest(
        name: "My World", worldSettings: MCMapManifestWorldSettings(version: "1.21", seed: 0), pins: [])

    @State private var redWindowEnvironment = RedWindowEnvironment()

    init() {
        UserDefaults.standard.set(Self.information.version, forKey: "CFBundleShortVersionString")
        UserDefaults.standard.set(Self.information.buildNumber, forKey: "CFBundleVersion")
        UserDefaults.standard.synchronize()
        do {
            try Tips.configure()
        } catch {
            print("Failed to configure tips: \(error.localizedDescription)")
        }
    }

    var body: some Scene {
        DocumentGroup(newDocument: CartographyMapFile(withManifest: .sampleFile)) { configuration in
            RedWindowContentView(file: configuration.$document)
                .toolbarRole(.editor)
                .environment(redWindowEnvironment)
                .environment(
                    \.bluemapService,
                    CartographyBluemapService(withConfiguration: configuration.document.integrations.bluemap)
                )
                .environment(\.documentURL, configuration.fileURL)
                .environment(\.clock, clock)
        }
        .onChange(of: scenePhase) { _, newValue in
            switch newValue {
            case .active:
                clock.start(timers: [.bluemap, .realtime])
            case .inactive, .background:
                fallthrough
            @unknown default:
                clock.stop(timers: [.bluemap, .realtime])
            }
        }
        .commands {
            MapCommands(environment: redWindowEnvironment)
            HelpCommands()
            CommandGroup(after: .pasteboard) {
                Button("Configure World...", systemImage: "globe") {
                    redWindowEnvironment.currentRoute = .worldEdit
                }
                .keyboardShortcut("E", modifiers: [.command, .shift])
            }
            CommandGroup(before: .saveItem) {
                Button("Find in File...", systemImage: "magnifyingglass") {
                    redWindowEnvironment.currentRoute = .search
                }
                .keyboardShortcut("F", modifiers: [.command, .shift])
            }
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
        #if os(macOS)
            .commands {
                CommandGroup(replacing: .appInfo) {
                    Button("About \(Self.information.name)") {
                        openWindow(id: .about)
                    }
                }
                CommandGroup(after: .windowArrangement) {
                    Button("Welcome to \(Self.information.name)") {
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

        DocumentLaunchScene(proxyMap: $proxyMap)

        #if os(macOS)
            Window("About \(Self.information.name)", id: "about") {
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

        CartographyGalleryScene()
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
