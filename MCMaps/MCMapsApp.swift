//
//  MCMapsApp.swift
//  MCMaps
//
//  Created by Marquis Kurt on 31-01-2025.
//

import SwiftUI

#if os(iOS)
    @MainActor
    func hideNavigationBar() {
        let activeScene = UIApplication.shared.connectedScenes
            .filter({ $0.activationState == .foregroundActive })
            .first

        if let windowScene = activeScene as? UIWindowScene {
            guard let currentWindow = windowScene.keyWindow else { return }
            if let navController = currentWindow.rootViewController as? UINavigationController {
                navController.isNavigationBarHidden = true
            }
        }
    }
#endif

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

    @Environment(\.openWindow) private var openWindow

    @State private var displayCreationWindow = false
    @State private var proxyMap = CartographyMap(seed: 0, mcVersion: "1.21", name: "My World", pins: [])

    var body: some Scene {
        DocumentGroup(newDocument: CartographyMapFile(map: .sampleFile)) { configuration in
            ContentView(file: configuration.$document)
                .toolbarRole(.editor)
                #if os(iOS)
                    .toolbarVisibility(.hidden, for: .navigationBar)
                #endif
        }
        #if os(macOS)
            .commands {
                CommandGroup(after: .windowArrangement) {
                    Button("Welcome to \(Self.appName)") {
                        openWindow(id: "launch")
                    }
                    .keyboardShortcut("0", modifiers: [.shift, .command])
                }
            }
        #endif

        DocumentLaunchView(displayCreationWindow: $displayCreationWindow, proxyMap: $proxyMap)
    }
}

#if DEBUG
    extension MCMapsApp {
        var testHooks: TestHooks { TestHooks(target: self) }

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
