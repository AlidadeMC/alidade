//
//  StringTests.swift
//  MCMaps
//
//  Created by Marquis Kurt on 24-06-2025.
//

import Foundation
import Testing

@testable import Alidade

struct StringTests {
    @Test func snakeCase() async throws {
        #expect("Red Window".snakeCase == "red_window")
        #expect("full Stop support".snakeCase == "full_stop_support")
    }
}
