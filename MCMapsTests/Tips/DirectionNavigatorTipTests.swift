//
//  DirectionNavigatorTipTests.swift
//  MCMaps
//
//  Created by Marquis Kurt on 11-03-2025.
//

import SwiftUI
import Testing
import TipKit

@testable import Alidade

struct DirectionNavigatorTipTests {
    @Test func tipConfiguration() async throws {
        let tip = DirectionNavigatorTip()

        #expect(DirectionNavigatorTip.viewDisplayed.id == "navigator.displayed")
        #expect(tip.title == Text("Move around the map."))
        #expect(tip.message != nil)
        #expect(tip.image != nil)
        #expect(!tip.rules.isEmpty)
        #expect(!tip.options.isEmpty)
    }
}
