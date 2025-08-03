//
//  CartographySearchService.swift
//  MCMaps
//
//  Created by Marquis Kurt on 08-02-2025.
//

import CubiomesKit
import Foundation
import MCMap

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
    struct SearchResult: Sendable, Equatable, Hashable {
        /// The pins that matched a given query.
        var pins: [CartographyMapPin]

        /// The integration data that matched a given query.
        var integratedData: [CartographyMapPin]

        /// The coordinates that matched a given query.
        ///
        /// This is typically populated when the query represents a coordinate that can be quickly jumped to, such as
        /// if the player provided a coordinate query.
        var coordinates: [CGPoint]

        /// Nearby biomes that matched within the specified radius.
        var biomes: [CartographyMapPin]

        /// Nearby structures that matched within the specified radius.
        var structures: [CartographyMapPin]

        /// Whether the search results are completely empty.
        var isEmpty: Bool {
            pins.isEmpty && coordinates.isEmpty && structures.isEmpty && biomes.isEmpty && integratedData.isEmpty
        }

        init() {
            self.pins = []
            self.coordinates = []
            self.structures = []
            self.biomes = []
            self.integratedData = []
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
        var integratedMarkers = [CartographyMapPin]()

        if context.file.supportedFeatures.contains(.integrations), context.file.integrations.bluemap.enabled {
            integratedMarkers.append(contentsOf: await getBluemapMarkers(in: context))
        }

        if let matches = query.matches(of: Constants.coordinateRegex).first?.output {
            if let x = Double(matches.1), let y = Double(matches.2) {
                results.coordinates.append(CGPoint(x: x, y: y))
            }
        }

        let playerPins = filterPins(context.file.pins, by: query, filters: filters)
        let filteredMarkers = filterPins(integratedMarkers, by: query, filters: filters)
        results.pins = playerPins
        results.integratedData = filteredMarkers

        if let structure = MinecraftStructure(string: query) {
            searchStructures(context, structure, &results)
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

    private func getBluemapMarkers(in context: SearchContext) async -> [CartographyMapPin] {
        let service = CartographyIntegrationService(
            serviceType: .bluemap,
            integrationSettings: context.file.integrations)
        do {
            let results: BluemapResults? = try await service.sync(dimension: context.dimension)
            guard let markers = results?.markers else {
                return []
            }
            let allMarkers = markers.map(\.value)
            return allMarkers.flatMap { group in
                group.markers.map { (id, marker) in
                    CartographyMapPin(
                        named: marker.label,
                        at: CGPoint(x: marker.position.x, y: marker.position.z),
                        color: .gray,
                        alternateIDs: [id]
                    )
                }
            }
        } catch {
            return []
        }
    }

    private func filterPins(
        _ pins: [CartographyMapPin],
        by query: Query,
        filters: SearchFilterGroup? = nil
    ) -> [CartographyMapPin] {
        var newPins = [CartographyMapPin]()
        for pin in pins {
            let nameMatches = pin.name.lowercased().contains(query.lowercased())
            if let filters = filters, !filters.isEmpty {
                if filters.matchTags(for: pin).isEmpty { continue }
                if !nameMatches, !query.isEmpty { continue }
                newPins.append(pin)
                continue
            }

            if !nameMatches { continue }
            newPins.append(pin)
        }
        return newPins
    }

    private func searchBiomes(
        query: String, mcVersion: String, world: MinecraftWorld, pos: Point3D<Int32>,
        dimension: MinecraftWorld.Dimension
    ) -> [CartographyMapPin] {
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
            CartographyMapPin(
                named: name,
                at: CGPoint(x: Double(foundBiome.x), y: Double(foundBiome.z)))
        }

        let cgPointOrigin = CGPoint(x: Double(pos.x), y: Double(pos.z))
        biomes.sort { first, second in
            first.position
                .manhattanDistance(to: cgPointOrigin) < second.position.manhattanDistance(to: cgPointOrigin)
        }
        return biomes
    }

    private func searchStructures(
        _ context: SearchContext,
        _ structure: MinecraftStructure,
        _ results: inout SearchResult
    ) {
        let foundStructures = context.world.findStructures(
            ofType: structure,
            at: context.position,
            inRadius: searchRadius,
            dimension: context.dimension
        )
        for foundStruct in foundStructures {
            results.structures
                .append(
                    CartographyMapPin(
                        named: structure.name,
                        at: CGPoint(x: Double(foundStruct.x), y: Double(foundStruct.z)),
                        color: structure.pinColor)
                )
        }

        let cgPointOrigin = CGPoint(minecraftPoint: context.position)
        results.structures.sort { first, second in
            first.position
                .manhattanDistance(to: cgPointOrigin) < second.position.manhattanDistance(to: cgPointOrigin)
        }
    }
}
