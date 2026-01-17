//
//  MCMapsAppTests.swift
//  MCMaps
//
//  Created by Marquis Kurt on 09-02-2025.
//

import MCMap
import SwiftUI
import Testing

@testable import Alidade

#if canImport(UIKit)
    import UIKit
#endif

@MainActor
struct MCMapsAppTests {
    @Test func appInit() throws {
        let app = MCMapsApp()
        let sut = app.testHooks

        #expect(sut.displayCreationWindow == false)
        #expect(
            sut.proxyMap
                == MCMapManifest(
                    name: "My World", worldSettings: MCMapManifestWorldSettings(version: "1.21", seed: 0), pins: []))
    }
}
