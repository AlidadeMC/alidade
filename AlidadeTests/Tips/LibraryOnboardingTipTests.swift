//
//  LibraryOnboardingTipTests.swift
//  MCMaps
//
//  Created by Marquis Kurt on 11-03-2025.
//

import SwiftUI
import Testing
import TipKit

@testable import Alidade

struct LibraryOnboardingTipTests {
    @Test func tipConfiguration() async throws {
        let tip = LibraryOnboardingTip()

        #expect(tip.title == Text("Browse and search your library."))
        #expect(tip.message != nil)
        #expect(tip.image == nil)
        #expect(!tip.options.isEmpty)
    }
}
