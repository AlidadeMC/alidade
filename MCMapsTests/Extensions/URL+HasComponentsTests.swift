//
//  URL+HasComponentsTests.swift
//  MCMaps
//
//  Created by Marquis Kurt on 01-03-2025.
//

import Foundation
import Testing

@testable import Alidade

struct URLHasComponentsTests {
    @Test(arguments: [
        ["Users"],
        ["Users", "Augenwaldburg.mcmap"],
        ["Documents"],
        ["Documents", "Augenwaldburg.mcmap"],
        ["weiss"]
    ])
    func hasComponentsMatches(components: [String]) async throws {
        let url = URL(filePath: "/Users/weiss/Documents/Augenwaldburg.mcmap")
        #expect(url.contains(components: components))
    }
}
