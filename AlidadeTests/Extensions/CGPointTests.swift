//
//  CGPointTests.swift
//  MCMaps
//
//  Created by Marquis Kurt on 04-03-2025.
//

import Foundation
import Testing

@testable import Alidade

struct CGPointTests {
    @Test func accessibilityReadout() async throws {
        let point = CGPoint(x: 1847, y: 1847)
        #expect(point.accessibilityReadout == "1,847, 1,847")
    }

    @Test func rounded() async throws {
        let point = CGPoint(x: 1847.118, y: 1963.9913)
        #expect(point.rounded() == CGPoint(x: 1847.0, y: 1964.0))
    }
}
