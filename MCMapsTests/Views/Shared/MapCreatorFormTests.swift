//
//  MapCreatorFormTests.swift
//  MCMaps
//
//  Created by Marquis Kurt on 12-02-2025.
//

import MCMap
import SwiftUI
import Testing
import ViewInspector

@testable import Alidade

@MainActor
struct MapCreatorFormTests {

    // TODO: Author tests to check form changes.
    // This might be tricky, however, as there needs to be a hook of some kind to know when the form is "submitted" per
    // field.

    @Test func formInitializes() throws {
        let worldName = Binding<String>(wrappedValue: "My World")
        let worldSettings = Binding<MCMapManifestWorldSettings>(
            wrappedValue: MCMapManifestWorldSettings(version: "1.21", seed: 123)
        )
        let integrations = Binding<CartographyMapFile.Integrations>(
            wrappedValue: CartographyMapFile(withManifest: .sampleFile).integrations
        )

        let view = MapCreatorForm(
            worldName: worldName,
            worldSettings: worldSettings,
            integrations: integrations
        ) { newView in
            #expect(newView.testHooks.seedString == "123")
        }
        defer { ViewHosting.expel() }
        ViewHosting.host(view: view)
    }
}
