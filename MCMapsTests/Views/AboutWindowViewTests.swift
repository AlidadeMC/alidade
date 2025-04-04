//
//  AboutWindowViewTests.swift
//  MCMaps
//
//  Created by Marquis Kurt on 15-03-2025.
//

import SwiftUI
import Testing
import ViewInspector

@testable import Alidade

// NOTE: More substantial tests should be written here, at least for the credits file loading...

@MainActor
struct AboutWindowViewTests {
    @Test func viewLayout() throws {
        let about = AboutWindowView()
        let sut = try about.inspect()
        #expect(!about.testHooks.versionString.isEmpty)
        #expect(about.testHooks.creditsFile == nil)
        #expect(!sut.isAbsent)
    }
}
