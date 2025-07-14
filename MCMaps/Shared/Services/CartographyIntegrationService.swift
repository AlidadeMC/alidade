//
//  CartographyIntegrationService.swift
//  MCMaps
//
//  Created by Marquis Kurt on 14-07-2025.
//

import CubiomesKit
import MCMapFormat
import os

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
    private let logger = Logger(subsystem: "net.marquiskurt.mcmaps", category: "\(CartographyIntegrationService.self)")

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
            logger.debug("☁️ Integrations are not enabled. Skipping fetch.")
            throw .integrationDisabled
        }

        switch serviceType {
        case .bluemap:
            self.logger.debug("☁️ Fetching data from Bluemap.")
            let response = try await fetchBluemapData(dimension: dimension)
            return response as? Response
        }
    }

    private func fetchBluemapData(dimension: MinecraftWorld.Dimension) async throws(ServiceError) -> BluemapResults {
        let bluemapSettings = integrationSettings.bluemap
        guard bluemapSettings.enabled else {
            logger.debug("☁️ Bluemap integration is not enabled. Skipping fetch.")
            throw .integrationDisabled
        }

        let itemsToFetch = bluemapSettings.displayOptions
        do {
            let response = await makeBluemapRequests(itemsToFetch: itemsToFetch, dimension: dimension)
            switch response {
            case .success(let results):
                self.logger.debug("☁️ Results were fetched. Returning to sender.")
                if results.isNone {
                    self.logger.warning("☁️ Bluemap results don't contain anything.")
                }
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
            logger.critical(
                "☁️ Service provider isn't a Bluemap service, despite the service type saying so. That's illegal."
            )
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
                        self.logger.error("☁️ Couldn't fetch markers: \(error.localizedDescription)")
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
                        self.logger.error("☁️ Couldn't fetch players: \(error.localizedDescription)")
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
                    self.logger.error("☁️ One or more fetch tasks failed: \(error.localizedDescription)")
                    return .failure(ServiceError.fetchTaskFailed(error))
                }
            }
            return .success(finalResult)
        }
    }
}
