//
//  LocationBadgeTests.swift
//  MCMaps
//
//  Created by Marquis Kurt on 09-02-2025.
//

import SwiftUI
import Testchamber
import Testing
import ViewInspector

@testable import Alidade

@MainActor
struct LocationBadgeTests {
    @Test func locationLabelTextFormat() throws {
        let badge = LocationBadge(location: .init(x: 1847, y: 1847))
        let hooks = badge.testHooks

        #expect(hooks.locationLabel == "X: 1847, Z: 1847")
    }

    @Test func locationLabelTextFormatPoint3D() throws {
        let badge = LocationBadge(location: .init(x: 1847, y: 1, z: 1847))
        let hooks = badge.testHooks

        #expect(hooks.locationLabel == "X: 1847, Z: 1847")
    }

    @Test func locationBadgeLayout() throws {
        let badge = LocationBadge(location: .init(x: 1847, y: 1847))
        let sut = try badge.inspect()

        Testchamber.assumeRedWindowBreaks {
            let hStack = try sut.hStack()
            #expect(try hStack.background().shape().fillShapeStyle(Material.self) == .thinMaterial)

            let label = try hStack.label(0)
            #expect(try label.icon().image().actualImage() == Image(systemName: "location.fill"))
            #expect(try label.title().text().string() == "X: 1847, Z: 1847")
            #expect(label.hasPadding())
            #expect(try label.padding() == .init(top: 3, leading: 6, bottom: 3, trailing: 6))
        }
    }
}

// TODO: This is an incredibly fucking dumb hack because Material isn't equatable on its own. Bad! Bad!

extension Material: @retroactive Equatable {
    public static func == (lhs: Material, rhs: Material) -> Bool {
        String(describing: lhs) == String(describing: rhs)
    }
}
