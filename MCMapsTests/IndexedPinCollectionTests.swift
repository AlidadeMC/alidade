//
//  IndexedPinCollectionTests.swift
//  MCMaps
//
//  Created by Marquis Kurt on 04-08-2025.
//

import Foundation
import MCMap
import Testing

@testable import Alidade

struct IndexedPinCollectionTests {
    var myPins = [
        CartographyMapPin(named: "Spawn", at: .zero),
        CartographyMapPin(named: "Another Pin", at: CGPoint(x: 132, y: 132)),
        CartographyMapPin(named: "Hotel Letztes Jahr", at: CGPoint(x: 1847, y: 1963))
    ]

    @Test func indexedPinCollectionConformances() async throws {
        let collection = IndexedPinCollection(myPins)
        #expect(collection.count == myPins.count)
        #expect(collection.startIndex == myPins.startIndex)
        #expect(collection.endIndex == myPins.endIndex)
        #expect(collection.index(after: collection.startIndex) == myPins.index(after: myPins.startIndex))

        let first = try #require(collection.first)
        #expect(first == IndexedPinCollection.Element(index: 0, content: myPins[0]))
    }

    @Test func indexedPinCollectionHashable() async throws {
        let collection = IndexedPinCollection(myPins)
        let hashValue = collection.hashValue
        #expect(hashValue != 0)
    }

    @Test func indexPinCollectionCodable() async throws {
        let collection = IndexedPinCollection(myPins)
        let jsonEncoder = JSONEncoder()
        let encoded = try jsonEncoder.encode(collection)

        #expect(!encoded.isEmpty)

        let jsonDecoder = JSONDecoder()
        let backToCollection = try jsonDecoder.decode(IndexedPinCollection.self, from: encoded)
        #expect(backToCollection == collection)

        #if swift(>=6.2)
        Attachment.record(encoded)
        #endif
    }
}
