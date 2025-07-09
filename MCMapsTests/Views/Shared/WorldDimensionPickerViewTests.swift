//
//  WorldDimensionPickerViewTests.swift
//  MCMaps
//
//  Created by Marquis Kurt on 13-02-2025.
//

import CubiomesKit
import SwiftUI
import Testchamber
import Testing
import ViewInspector

@testable import Alidade

@MainActor
struct WorldDimensionPickerViewTests {
    @Test func viewLayout() throws {
        let dimension: Binding<MinecraftWorld.Dimension> = .init(wrappedValue: .overworld)
        let view = WorldDimensionPickerView(selection: dimension)
        let sut = try view.inspect()

        let picker = try sut.picker()
        #expect(try picker.labelView().text().string() == "Dimension")

        let overworld = try picker.label(0)
        #expect(try overworld.title().text().string() == "Overworld")
        #expect(try overworld.icon().image().actualImage() == Image(systemName: "tree"))
        Testchamber.assumeRedWindowBreaks {
            let tag = try overworld.tag()
            #expect(tag as? MinecraftWorld.Dimension == MinecraftWorld.Dimension.overworld)

        }

        let nether = try picker.label(1)
        #expect(try nether.title().text().string() == "Nether")
        #expect(try nether.icon().image().actualImage() == Image(systemName: "flame"))
        #expect(try nether.tag() as? MinecraftWorld.Dimension == MinecraftWorld.Dimension.nether)

        let end = try picker.label(2)
        #expect(try end.title().text().string() == "End")
        #expect(try end.icon().image().actualImage() == Image(systemName: "sparkles"))
        #expect(try end.tag() as? MinecraftWorld.Dimension == MinecraftWorld.Dimension.end)
    }
}
