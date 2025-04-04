//
//  ContentViewTests.swift
//  MCMaps
//
//  Created by Marquis Kurt on 26-02-2025.
//

import SwiftUI
import Testing
import ViewInspector

@testable import Alidade

@MainActor
struct ContentViewTests {
    @Test func contentViewInit() async throws {
        let file = Binding(wrappedValue: CartographyMapFile(map: .sampleFile))
        let view = ContentView(file: file)

        #expect(view.testHooks.displaySidebarSheet == false)
    }
}
