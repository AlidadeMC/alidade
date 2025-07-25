//
//  CartographyNamedLocationViewTests.swift
//  MCMaps
//
//  Created by Marquis Kurt on 10-02-2025.
//

import MCMap
import SwiftUI
import Testing
import ViewInspector

@testable import Alidade
@testable import AlidadeUI

@MainActor
struct CartographyNamedLocationViewTests {
    @Test(.tags(.legacyUI))
    func initalizeWithPin() throws {
        let view = NamedLocationView(pin: CartographyMapPin(named: "Pin", at: .zero, color: .blue))

        #expect(view.testHooks.name == "Pin")
        #expect(view.testHooks.location == .zero)
        #expect(view.testHooks.color == .blue)
        #expect(view.testHooks.systemImage == "mappin")
    }
}
