//
//  EdgeInsetsTests.swift
//  MCMaps
//
//  Created by Marquis Kurt on 19-02-2025.
//

import SwiftUI
import Testing

@testable import Alidade

struct EdgeInsetsTests {
    @Test func edgeInsetZeroMatches() async throws {
        let expected = EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
        #expect(EdgeInsets.zero == expected)
    }

    @Test func edgeInsetConvenienceInit() async throws {
        #expect(EdgeInsets(all: 1) == .init(top: 1, leading: 1, bottom: 1, trailing: 1))
    }
}
