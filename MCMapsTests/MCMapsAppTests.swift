//
//  MCMapsAppTests.swift
//  MCMaps
//
//  Created by Marquis Kurt on 09-02-2025.
//

import SwiftUI
import Testing

@testable import Alidade

#if canImport(UIKit)
    import UIKit
#endif

@MainActor
struct MCMapsAppTests {
    #if os(iOS)
        @Test func hideNavigationBarHides() throws {
            hideNavigationBar()

            let activeScene = UIApplication.shared.connectedScenes
                .filter({ $0.activationState == .foregroundActive })
                .first

            if let windowScene = activeScene as? UIWindowScene {
                guard let currentWindow = windowScene.keyWindow else { return }
                if let navController = currentWindow.rootViewController as? UINavigationController {
                    #expect(navController.isNavigationBarHidden == true)
                }
            }
        }
    #endif

    @Test func appInit() throws {
        let app = MCMapsApp()
        let sut = app.testHooks

        #expect(sut.displayCreationWindow == false)
        #expect(sut.proxyMap == .init(seed: 0, mcVersion: "1.21", name: "My World", pins: []))
    }
}
