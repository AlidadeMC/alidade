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
        static let defaultSearchRadius: Int32 = 20
    }

    var searchRadius: Int32 = Constants.defaultSearchRadius

    init() {
        self.searchRadius = Constants.defaultSearchRadius
    }

    func search(
        _ query: Query, world: MinecraftWorld,
        file: CartographyMapFile,
        currentPosition: Point3D<Int32> = .zero,
        dimension: MinecraftWorld.Dimension = .overworld
    ) -> SearchResult {
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

        if let structure = MinecraftStructure(string: query) {
            let foundStructures = world.findStructures(
                ofType: structure,
                at: currentPosition,
                inRadius: searchRadius,
                dimension: dimension
            )
            for foundStruct in foundStructures {
                results.structures
                    .append(
                        CartographyMapPin(
                            position: CGPoint(x: Double(foundStruct.x), y: Double(foundStruct.z)),
                            name: structure.name,
                            color: structure.pinColor)
                    )
            }
        }

        return results
    }
}
