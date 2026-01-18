//
//  PinPhotoOnboardingTipTests.swift
//  MCMaps
//
//  Created by Marquis Kurt on 22-03-2025.
//

import SwiftUI
import Testing
import TipKit

@testable import Alidade

struct PinPhotoOnboardingTipTests {
    @Test func tipConfiguration() async throws {
        let tip = PinPhotoOnboardingTip()

        #expect(tip.title == Text("Make it memorable."))
        #expect(tip.message != nil)
        #expect(tip.image != nil)
        #expect(!tip.options.isEmpty)
    }
}
