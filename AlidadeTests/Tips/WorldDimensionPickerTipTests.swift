//
//  WorldDimensionPickerTipTests.swift
//  MCMaps
//
//  Created by Marquis Kurt on 11-03-2025.
//

import SwiftUI
import Testing
import TipKit

@testable import Alidade

struct WorldDimensionPickerTipTests {
    @Test func tipConfiguration() async throws {
        let tip = WorldDimensionPickerTip()

        #expect(tip.title == Text("Switch between dimensions."))
        #expect(WorldDimensionPickerTip.viewDisplayed.id == "dimensionpicker.displayed")
        #expect(tip.message != nil)
        #expect(tip.image != nil)
        #expect(!tip.rules.isEmpty)
        #expect(!tip.options.isEmpty)
    }
}
