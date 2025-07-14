//
//  CartographyIntegrationService.swift
//  MCMaps
//
//  Created by Marquis Kurt on 14-07-2025.
//

import CubiomesKit
import MCMapFormat

protocol CartographyIntegrationServiceProvider {
    associatedtype Endpoint: Sendable
    associatedtype Configuration: Sendable

    func fetch<T: Codable>(
        endpoint: Endpoint,
        for dimension: MinecraftWorld.Dimension
    ) async throws(NetworkServicableError) -> T
}

protocol CartographyIntegrationServiceData {
    associatedtype Configuration
    typealias AnnotationContent = any MinecraftMapBuilderContent
    func annotations(from configuration: Configuration) -> [AnnotationContent]
}

extension CartographyBluemapService: CartographyIntegrationServiceProvider {
    typealias Configuration = MCMapBluemapIntegration
}

actor CartographyIntegrationService {
    typealias IntegrationSettings = CartographyMapFile.Integrations

    private typealias BluemapResult = Result<BluemapResults, any Error>

    enum ServiceType {
        case bluemap
    }

    enum ServiceError: Error {
        case integrationDisabled
        case mismatchingService
        case fetchTaskFailed(Error)
    }

    let integrationSettings: IntegrationSettings
    let serviceType: ServiceType

    private var service: any CartographyIntegrationServiceProvider

    init(serviceType: ServiceType, integrationSettings: CartographyMapFile.Integrations) {
        self.serviceType = serviceType
        self.integrationSettings = integrationSettings
        switch serviceType {
        case .bluemap:
            self.service = CartographyBluemapService(withConfiguration: integrationSettings.bluemap)
        }
    }

    func sync<Response>(dimension: MinecraftWorld.Dimension) async throws(ServiceError) -> Response? {
        guard integrationSettings.enabled else {
            throw .integrationDisabled
        }

        switch serviceType {
        case .bluemap:
            let response = try await fetchBluemapData(dimension: dimension)
            return response as? Response
        }
    }

    private func fetchBluemapData(dimension: MinecraftWorld.Dimension) async throws(ServiceError) -> BluemapResults {
        let bluemapSettings = integrationSettings.bluemap
        guard bluemapSettings.enabled else {
            throw .integrationDisabled
        }

        let itemsToFetch = bluemapSettings.displayOptions
        do {
            let response = await makeBluemapRequests(itemsToFetch: itemsToFetch, dimension: dimension)
            switch response {
            case .success(let results):
                return results
            case .failure(let error):
                throw error
            }
        } catch ServiceError.mismatchingService {
            throw .mismatchingService
        } catch {
            throw .fetchTaskFailed(error)
        }
    }

    private func makeBluemapRequests(
        itemsToFetch: BluemapDisplayProperties,
        dimension: MinecraftWorld.Dimension
    ) async -> Result<BluemapResults, any Error> {
        guard let service = service as? CartographyBluemapService else {
            return .failure(ServiceError.mismatchingService)
        }
        return await withTaskGroup(of: BluemapResult.self, returning: BluemapResult.self) { group in
            if itemsToFetch.contains(.deathMarkers) || itemsToFetch.contains(.markers) {
                group.addTask {
                    do {
                        let response: [String: BluemapMarkerAnnotationGroup] = try await service.fetch(
                            endpoint: .markers,
                            for: dimension
                        )
                        return .success(BluemapResults(markers: response))
                    } catch {
                        return .failure(error)
                    }
                }
            }
            if itemsToFetch.contains(.players) {
                group.addTask {
                    do {
                        let response: BluemapPlayerResponse = try await service.fetch(
                            endpoint: .players,
                            for: dimension
                        )
                        return .success(BluemapResults(players: response))
                    } catch {
                        return .failure(error)
                    }
                }
            }

            var finalResult = BluemapResults()
            for await result in group {
                switch result {
                case .success(let results):
                    finalResult = finalResult.merged(with: results)
                case .failure(let error):
                    return .failure(ServiceError.fetchTaskFailed(error))
                }
            }
            return .success(finalResult)
        }
    }
}
