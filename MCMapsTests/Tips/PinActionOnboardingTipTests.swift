//
//  PinActionOnboardingTipTests.swift
//  MCMaps
//
//  Created by Marquis Kurt on 29-03-2025.
//

import SwiftUI
import Testing

@testable import Alidade

struct PinActionOnboardingTipTests {
    @Test func tipConfiguration() async throws {
        let tip = PinActionOnboardingTip()
        
        #expect(tip.title == Text("Pin a location."))
        #expect(tip.message != nil)
        #expect(tip.image == nil)
        #expect(!tip.options.isEmpty)
        #expect(!tip.rules.isEmpty)
    }
}
