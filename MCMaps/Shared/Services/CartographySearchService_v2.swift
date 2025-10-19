//
//  CartographySearchService_v2.swift
//  MCMaps
//
//  Created by Marquis Kurt on 19-10-2025.
//

import AlidadeSearchEngine
import CubiomesKit
import MCMap
import Foundation

class CartographySearchService_v2 {
    struct Context: Sendable {
        var world: MinecraftWorld
        var file: CartographyMapFile
        var position: MinecraftPoint = .zero
        var dimension: MinecraftWorld.Dimension = .overworld
    }

    struct SearchResult: Sendable {
        var pins: [CartographyMapPin] = []
        var integratedData: [CartographyMapPin] = []
        var biomes: [CartographyMapPin] = []
        var structures: [CartographyMapPin] = []

        var isEmpty: Bool {
            [pins, integratedData, biomes, structures].allSatisfy(\.isEmpty)
        }
    }

    private enum Constants {
        static let defaultSearchRadius: Int32 = 20
    }

    var searchRadius: Int32 = Constants.defaultSearchRadius

    init() {
        self.searchRadius = Constants.defaultSearchRadius
    }
}

extension CartographySearchService_v2: AlidadeSearchEngine {
    func search(query: AlidadeSearchQuery, in context: Context) async -> SearchResult {
        var results = SearchResult()
        var position = context.position
        var dimension = context.dimension
        var integratedMarkers = [CartographyMapPin]()

        if let origin = query.origin {
            position = MinecraftPoint(cgPoint: origin)
        }

        if let translatedDim = MinecraftWorld.Dimension(query: query) {
            dimension = translatedDim
        }

        if context.file.supportedFeatures.contains(.integrations), context.file.integrations.bluemap.enabled {
            integratedMarkers.append(contentsOf: await getBluemapMarkers(in: context))
        }

        let playerPins = filterPins(context.file.pins, by: query)
        let filteredMarkers = filterPins(integratedMarkers, by: query)
        results.pins = playerPins
        results.integratedData = filteredMarkers

        if let structure = MinecraftStructure(string: query.request) {
            searchStructures(at: position, context, structure, dimension, &results)
        }

        results.biomes = searchBiomes(
            query: query.request,
            mcVersion: context.file.manifest.worldSettings.version,
            world: context.world,
            pos: position,
            dimension: dimension
        )

        return results
    }

    private func getBluemapMarkers(in context: Context) async -> [CartographyMapPin] {
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

    private func filterPins(_ pins: [CartographyMapPin], by query: AlidadeSearchQuery) -> [CartographyMapPin] {
        var newPins = [CartographyMapPin]()
        for pin in pins {
            let nameMatches = pin.name.lowercased().contains(query.request.lowercased())
            if !query.tags.isEmpty, let tags = pin.tags {
                if tags.isDisjoint(with: query.tags) { continue }
                if !nameMatches, !query.request.isEmpty { continue }
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
        at position: MinecraftPoint,
        _ context: Context,
        _ structure: MinecraftStructure,
        _ dimension: MinecraftWorld.Dimension,
        _ results: inout SearchResult
    ) {
        let foundStructures = context.world.findStructures(
            ofType: structure,
            at: position,
            inRadius: searchRadius,
            dimension: dimension
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
