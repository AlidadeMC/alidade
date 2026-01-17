//
//  RandomAccessDictionaryTests.swift
//  MCMaps
//
//  Created by Marquis Kurt on 04-08-2025.
//

import Foundation
import Testing

@testable import Alidade

struct RandomAccessDictionaryTests {
    let originalDict = ["foo": 1, "bar": 13, "baz": 1847]

    @Test func collectionConformances() async throws {
        let rad = RandomAccessDictionary(originalDict)

        #expect(rad.count == 3)
        #expect(rad.startIndex == originalDict.startIndex)
        #expect(rad.endIndex == originalDict.endIndex)
        #expect(rad.index(after: rad.startIndex) == originalDict.index(after: originalDict.startIndex))
    }

    @Test func randomAccessConformances() async throws {
        let rad = RandomAccessDictionary(originalDict)

        #expect(rad.index(before: rad.endIndex).hashValue != 0)
    }
}
