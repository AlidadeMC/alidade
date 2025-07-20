//
//  ContentViewTests.swift
//  MCMaps
//
//  Created by Marquis Kurt on 26-02-2025.
//

import MCMap
import SwiftUI
import Testing
import ViewInspector

@testable import Alidade

@MainActor
struct ContentViewTests {
    @Test(.tags(.legacyUI))
    func contentViewInit() async throws {
        let file = Binding(wrappedValue: CartographyMapFile(withManifest: .sampleFile))
        let view = LegacyContentView(file: file)

        #expect(view.testHooks.displaySidebarSheet == false)
    }
}
