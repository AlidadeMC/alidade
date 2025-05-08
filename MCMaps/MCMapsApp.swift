//
//  MCMapsApp.swift
//  MCMaps
//
//  Created by Marquis Kurt on 31-01-2025.
//

import SwiftUI
import TipKit

/// The main entry point for the Alidade app.
@main
struct MCMapsApp: App {
    /// The app's display name as it appears in the Info.plist file.
    static var appName: String {
        Bundle.main.infoDictionary?["CFBundleDisplayName"] as? String ?? ""
    }

    /// The app's main version as it appears in the Info.plist file.
    static var version: String {
        Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "0.0"
    }

    /// The app's build number as it appears in the Info.plist file.
    static var buildNumber: String {
        Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "0"
    }

    static var copyrightString: String {
        Bundle.main.infoDictionary?["NSHumanReadableCopyright"] as? String ?? ""
    }

    @Environment(\.openWindow) private var openWindow
    @Environment(\.openURL) private var openURL

    @State private var displayCreationWindow = false
    @State private var proxyMap = CartographyMap(seed: 0, mcVersion: "1.21", name: "My World", pins: [])

    init() {
        do {
            try Tips.configure()
        } catch {
            print("Failed to configure tips: \(error.localizedDescription)")
        }
    }

    var body: some Scene {
        DocumentGroup(newDocument: CartographyMapFile(withManifest: .sampleFile)) { configuration in
            ContentView(file: configuration.$document)
                .toolbarRole(.editor)
                #if os(iOS)
                    .toolbarVisibility(.hidden, for: .navigationBar)
                #endif
        }
        #if os(macOS)
            .commands {
                CommandGroup(replacing: .appInfo) {
                    Button("About \(Self.appName)") {
                        openWindow(id: "about")
                    }
                }
                CommandGroup(after: .windowArrangement) {
                    Button("Welcome to \(Self.appName)") {
                        openWindow(id: "launch")
                    }
                    .keyboardShortcut("0", modifiers: [.shift, .command])
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
        #endif
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

            var proxyMap: CartographyMap {
                target.proxyMap
            }
        }
    }
#endif
