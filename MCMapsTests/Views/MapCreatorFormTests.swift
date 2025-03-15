//
//  MapCreatorFormTests.swift
//  MCMaps
//
//  Created by Marquis Kurt on 12-02-2025.
//

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
        let worldName: Binding<String> = .init(wrappedValue: "My World")
        let minecraftVersion: Binding<String> = .init(wrappedValue: "1.21")
        let minecraftSeed: Binding<Int64> = .init(wrappedValue: 123)
        let view = MapCreatorForm(worldName: worldName, mcVersion: minecraftVersion, seed: minecraftSeed) { newView in
            #expect(newView.testHooks.seedString == "123")
        }
        defer { ViewHosting.expel() }
        ViewHosting.host(view: view)
    }
}
