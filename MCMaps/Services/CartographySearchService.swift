//
//  CartographySearchService.swift
//  MCMaps
//
//  Created by Marquis Kurt on 08-02-2025.
//

import CubiomesKit
import Foundation

/// A service that searches and filters content in Minecraft worlds and `.mcmap` files.
class CartographySearchService {
    /// The type of query used to initiate searches.
    typealias Query = String

    /// A structure that defines a search context.
    struct SearchContext: Sendable {
        /// The world to be searching.
        var world: MinecraftWorld

        /// The file to be searching.
        var file: CartographyMapFile

        /// The player's current position in the world.
        var position: MinecraftPoint = .zero

        /// The world's current dimension.
        var dimension: MinecraftWorld.Dimension = .overworld
    }

    /// A structure representing a set of results the search service has returned.
    struct SearchResult: Sendable, Equatable {
        /// The pins that matched a given query.
        var pins: [MCMapManifestPin]

        /// The coordinates that matched a given query.
        ///
        /// This is typically populated when the query represents a coordinate that can be quickly jumped to, such as
        /// if the player provided a coordinate query.
        var coordinates: [CGPoint]

        /// Nearby biomes that matched within the specified radius.
        var biomes: [MCMapManifestPin]

        /// Nearby structures that matched within the specified radius.
        var structures: [MCMapManifestPin]

        /// Whether the search results are completely empty.
        var isEmpty: Bool {
            pins.isEmpty && coordinates.isEmpty && structures.isEmpty && biomes.isEmpty
        }

        init() {
            self.pins = []
            self.coordinates = []
            self.structures = []
            self.biomes = []
        }
    }

    private enum Constants {
        nonisolated(unsafe) static let coordinateRegex = /(-?\d+), (-?\d+)/
        static let defaultSearchRadius: Int32 = 20
    }

    /// The search radius for the search service to use when searching for structures.
    ///
    /// The default search radius is twenty blocks wide.
    var searchRadius: Int32 = Constants.defaultSearchRadius

    /// Creates a search service.
    init() {
        self.searchRadius = Constants.defaultSearchRadius
    }

    /// Performs a search operation with a specified query.
    /// - Parameter query: The query to use for searching the world.
    /// - Parameter context: The context in which to perform a search operation.
    /// - Parameter filters: The filters to apply in this search.
    func search(for query: Query, in context: SearchContext, filters: SearchFilterGroup? = nil) async -> SearchResult {
        var results = SearchResult()

        if let matches = query.matches(of: Constants.coordinateRegex).first?.output {
            if let x = Double(matches.1), let y = Double(matches.2) {
                results.coordinates.append(CGPoint(x: x, y: y))
            }
        }

        for pin in context.file.manifest.pins {
            guard pin.name.lowercased().contains(query.lowercased()) else {
                continue
            }
            if let filters = filters, filters.matchTags(for: pin).isEmpty {
                continue
            }
            results.pins.append(pin)
        }

        if let structure = MinecraftStructure(string: query) {
            let foundStructures = context.world.findStructures(
                ofType: structure,
                at: context.position,
                inRadius: searchRadius,
                dimension: context.dimension
            )
            for foundStruct in foundStructures {
                results.structures
                    .append(
                        MCMapManifestPin(
                            position: CGPoint(x: Double(foundStruct.x), y: Double(foundStruct.z)),
                            name: structure.name,
                            color: structure.pinColor)
                    )
            }

            let cgPointOrigin = CGPoint(minecraftPoint: context.position)
            results.structures.sort { first, second in
                first.position
                    .manhattanDistance(to: cgPointOrigin) < second.position.manhattanDistance(to: cgPointOrigin)
            }
        }

        results.biomes = searchBiomes(
            query: query,
            mcVersion: context.file.manifest.worldSettings.version,
            world: context.world,
            pos: context.position,
            dimension: context.dimension
        )

        return results
    }

    private func searchBiomes(
        query: String, mcVersion: String, world: MinecraftWorld, pos: Point3D<Int32>,
        dimension: MinecraftWorld.Dimension
    ) -> [MCMapManifestPin] {
        guard let biome = MinecraftBiome(localizedString: query, mcVersion: mcVersion) else {
            return []
        }
        let foundBiomes = world.findBiomes(
            ofType: biome,
            at: pos,
            inRadius: 8000,
            dimension: dimension
        )
        let name = biome.localizedString(for: world.version)
        var biomes = foundBiomes.map { foundBiome in
            MCMapManifestPin(
                position: CGPoint(x: Double(foundBiome.x), y: Double(foundBiome.z)),
                name: name)
        }

        let cgPointOrigin = CGPoint(x: Double(pos.x), y: Double(pos.z))
        biomes.sort { first, second in
            first.position
                .manhattanDistance(to: cgPointOrigin) < second.position.manhattanDistance(to: cgPointOrigin)
        }
        return biomes
    }
}
