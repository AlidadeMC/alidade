//
//  CartographySearchServiceFilterGroupTests.swift
//  MCMaps
//
//  Created by Marquis Kurt on 01-06-2025.
//

import Foundation
import Testing

@testable import Alidade

struct CartographySearchServiceFilterGroupTests {
    typealias SearchFilterGroup = CartographySearchService.SearchFilterGroup

    @Test func initialize() async throws {
        let group = SearchFilterGroup(filters: [.tag("foo")])

        #expect(!group.isEmpty)
        #expect(group.first == .tag("foo"))
        #expect(group.index(after: group.startIndex) == group.endIndex)
    }

    @Test func matchTags() async throws {
        let group = SearchFilterGroup(filters: [.tag("Foo"), .tag("Bar"), .tag("Baz")])
        let pin = MCMapManifestPin(position: .zero, name: "Spawn", tags: ["Foo", "Baz"])

        let matches = group.matchTags(for: pin)
        #expect(matches.count == 2)
        #expect(matches == [.tag("Foo"), .tag("Baz")])
    }
}
