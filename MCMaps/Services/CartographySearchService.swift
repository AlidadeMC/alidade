//
//  CartographySearchService.swift
//  MCMaps
//
//  Created by Marquis Kurt on 08-02-2025.
//

import CubiomesKit
import Foundation

class CartographySearchService {
    typealias Query = String

    struct SearchResult: Sendable, Equatable {
        var pins: [CartographyMapPin]
        var coordinates: [CGPoint]
        var structures: [CartographyMapPin]

        var isEmpty: Bool {
            pins.isEmpty && coordinates.isEmpty && structures.isEmpty
        }

        init() {
            self.pins = []
            self.coordinates = []
            self.structures = []
        }
    }

    enum Constants {
        static let coordinateRegex = /(-?\d+), (-?\d+)/
    }

    func search(_ query: Query, world: MinecraftWorld, file: CartographyMapFile) -> SearchResult {
        var results = SearchResult()

        if let matches = query.matches(of: Constants.coordinateRegex).first?.output {
            if let x = Double(matches.1), let y = Double(matches.2) {
                results.coordinates.append(.init(x: x, y: y))
            }
        }

        for pin in file.map.pins {
            guard pin.name.lowercased().contains(query.lowercased()) else {
                continue
            }
            results.pins.append(pin)
        }

        return results
    }
}
