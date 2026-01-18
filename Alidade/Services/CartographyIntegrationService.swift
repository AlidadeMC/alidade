//
//  CartographyIntegrationService.swift
//  MCMaps
//
//  Created by Marquis Kurt on 14-07-2025.
//

import CubiomesKit
import Foundation
import MCMap
import os

/// A protocol that describes a provider for an integration service.
///
/// The ``CartographyIntegrationService`` will attempt to initialize a provider of this type when creating the service
/// based on the appropriate service type.
protocol CartographyIntegrationServiceProvider {
    /// An type representing the various endpoints the service can make requests to.
    associatedtype Endpoint: Sendable

    /// A type representing the model used to configure the service provider.
    associatedtype Configuration: Sendable

    /// Make a request to a specified endpoint relative to the given world dimension, decoding the response.
    /// - Parameter endpoint: The endpoint to make a request to.
    /// - Parameter dimension: The dimension relevant to the request.
    func fetch<T: Codable>(
        endpoint: Endpoint,
        for dimension: MinecraftWorld.Dimension
    ) async throws(NetworkServicableError) -> T
}

/// A protocol that represents a collective response type from ``CartographyIntegrationService``.
///
/// Some requests in the ``CartographyIntegrationService`` will be called concurrently and will fold into a singular
/// type. This protocol defines the general layout for these types, and provides a facility for converting the requested
/// data into annotations that `MinecraftMap` can use.
protocol CartographyIntegrationServiceData {
    /// A type representing the model used to configure the data when creating an annotation.
    associatedtype Configuration

    /// A type alias representing Minecraft map annotation content.
    typealias AnnotationContent = any MinecraftMapBuilderContent

    /// Generates an array of annotations from the current data, configured by a given configuration.
    /// - Parameter configuration: The configuration to configure the annotations with.
    func annotations(from configuration: Configuration) -> [AnnotationContent]
}

extension CartographyBluemapService: CartographyIntegrationServiceProvider {
    typealias Configuration = MCMapBluemapIntegration
}

/// A service that makes requests to integration servers.
///
/// This type is generally used to fetch data from integrations asynchronously. For example, to make calls to the
/// Bluemap service:
/// ```swift
/// let service = CartographyIntegrationService(
///     serviceType: .bluemap,
///     integrationSettings: ...)
///
/// let data: BluemapResults? = await service
///     .sync(dimension: .overworld)
/// ```
actor CartographyIntegrationService {
    /// A typealias representing the settings for a given integration.
    typealias IntegrationSettings = CartographyMapFile.Integrations

    private typealias BluemapResult = Result<BluemapResults, any Error>

    /// An enumeration of the integrations supported by this service.
    enum ServiceType {
        case bluemap
    }

    /// An enumeration of the types of sync requests.
    enum SyncType {
        /// Fetch data used for a regular context.
        case regular

        /// Fetch data used for realtime updates.
        case realtime

        fileprivate var logValue: String {
            switch self {
            case .regular: "Regular"
            case .realtime: "Realtime"
            }
        }
    }

    /// An enumeration of the errors that the service can throw when attempting to make requests.
    enum ServiceError: Equatable, Error {
        /// The integration is disabled.
        case integrationDisabled

        /// The service provider doesn't match the expected service type.
        ///
        /// This error is generally not caused by the end user, but rather an internal implementation detail.
        case mismatchingService

        /// The fetch task failed.
        /// - Parameter error: The error that was thrown by the task.
        case fetchTaskFailed(Error)

        static func == (lhs: ServiceError, rhs: ServiceError) -> Bool {
            switch (lhs, rhs) {
            case (.integrationDisabled, .integrationDisabled):
                return true
            case (.mismatchingService, .mismatchingService):
                return true
            case (.fetchTaskFailed(let lhsErr), .fetchTaskFailed(let rhsErr)):
                return lhsErr.localizedDescription == rhsErr.localizedDescription
            default:
                return false
            }
        }
    }

    /// The integration settings used to configure the service.
    let integrationSettings: IntegrationSettings

    /// The service type, used to configure which providers to call.
    let serviceType: ServiceType

    private var service: any CartographyIntegrationServiceProvider
    private let logger = Logger(subsystem: "net.marquiskurt.mcmaps", category: "\(CartographyIntegrationService.self)")

    /// Initialize a service of a given type with integration settings.
    /// - Parameter serviceType: The service type to use with the integration service.
    /// - Parameter integrationSettings: The settings for integrations used to configure this service.
    init(
        serviceType: ServiceType,
        integrationSettings: CartographyMapFile.Integrations,
        session: any NetworkServiceable = URLSession(configuration: .default)
    ) {
        self.serviceType = serviceType
        self.integrationSettings = integrationSettings
        switch serviceType {
        case .bluemap:
            self.service = CartographyBluemapService(withConfiguration: integrationSettings.bluemap, session: session)
        }
    }

    /// Synchronize the current dataset from the integrations that the service supports, decoding the response.
    /// - Parameter dimension: The Minecraft world dimension to perform the synchronization operation under.
    func sync<Response: CartographyIntegrationServiceData>(
        dimension: MinecraftWorld.Dimension,
        syncType: SyncType = .regular
    ) async throws(ServiceError) -> Response? {
        guard integrationSettings.enabled else {
            logger.debug("☁️ Integrations are not enabled. Skipping fetch.")
            throw .integrationDisabled
        }

        switch serviceType {
        case .bluemap:
            self.logger.debug("☁️ (\(syncType.logValue)) Fetching data from Bluemap.")
            let response = try await fetchBluemapData(dimension: dimension, syncType: syncType)
            return response as? Response
        }
    }

    private func fetchBluemapData(
        dimension: MinecraftWorld.Dimension,
        syncType: SyncType = .regular
    ) async throws(ServiceError) -> BluemapResults {
        let bluemapSettings = integrationSettings.bluemap
        guard bluemapSettings.enabled else {
            logger.debug("☁️ (\(syncType.logValue)) Bluemap integration is not enabled. Skipping fetch.")
            throw .integrationDisabled
        }

        if syncType == .realtime, !bluemapSettings.realtime {
            logger.debug("☁️ (\(syncType.logValue)) Bluemap realtime sync is not enabled. Skipping fetch.")
            throw .integrationDisabled
        }

        let itemsToFetch = syncType == .realtime ? [.players] : bluemapSettings.displayOptions
        do {
            let response = await makeBluemapRequests(itemsToFetch: itemsToFetch, dimension: dimension)
            switch response {
            case .success(let results):
                self.logger.debug("☁️ (\(syncType.logValue)) Results were fetched. Returning to sender.")
                if results.isEmpty {
                    self.logger.warning("☁️ (\(syncType.logValue)) Bluemap results don't contain anything.")
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
