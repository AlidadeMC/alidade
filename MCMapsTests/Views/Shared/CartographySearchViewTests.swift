//
//  CartographySearchViewTests.swift
//  MCMaps
//
//  Created by Marquis Kurt on 08-06-2025.
//

import CubiomesKit
import MCMapFormat
import SwiftUI
import Testing
import ViewInspector

@testable import Alidade

@MainActor
struct CartographySearchViewTests {
    @Test func viewLayout() throws {
        let file = CartographyMapFile(withManifest: .sampleFile)
        let position = MinecraftPoint.zero
        let searchView = CartographySearchView(file: file, position: position, dimension: .overworld) {
            Text("Initial!")
        } results: { result in
            Text("Results!")
        }

        #expect(searchView.testHooks.searchQuery.isEmpty)
        #expect(searchView.testHooks.searchState == .initial)
    }
}
