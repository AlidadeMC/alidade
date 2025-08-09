//
//  ManagedAnnotatedMap.swift
//  MCMaps
//
//  Created by Marquis Kurt on 03-08-2025.
//

import CubiomesKit
import MCMap
import os
import SwiftUI

/// An abstract view used to manage providing annotations for a map.
///
/// This view automatically handles fetching from integrations when enabled, and it will filter markers that have
/// similar IDs.
struct ManagedAnnotatedMap<MapContent: View>: View {
    private typealias IntegrationServiceType = CartographyIntegrationService.ServiceType

    /// The file to read from.
    var file: CartographyMapFile

    /// The current world dimension.
    var dimension: MinecraftWorld.Dimension

    @Environment(\.bluemapService) private var bluemapService
    @Environment(\.clock) private var clock

    var mapContent: (IntegrationFetchState, [any MinecraftMapBuilderContent]) -> MapContent

    @State private var integrationData = [IntegrationServiceType: any CartographyIntegrationServiceData]()
    @State private var integrationFetchState = IntegrationFetchState.initial

    private var integrationAnnotations: [any MinecraftMapBuilderContent] {
        var annotations = [any MinecraftMapBuilderContent]()
        for (key, value) in integrationData {
            switch key {
            case .bluemap:
                if let data = value as? BluemapResults {
                    annotations.append(contentsOf: data.annotations(from: file.integrations.bluemap))
                }
            }
        }
        return annotations
    }

    private let logger = Logger(subsystem: "dev.alidade.mcmaps", category: "\(ManagedAnnotatedMap.self)")

    var body: some View {
        mapContent(integrationFetchState, constructAnnotations())
            .task {
                if file.integrations.bluemap.enabled {
                    clock.setup(timer: .bluemap, at: file.integrations.bluemap.refreshRate)
                    clock.start(timer: .bluemap)
                    if file.integrations.bluemap.realtime {
                        clock.start(timer: .realtime)
                    }
                }
                await updateIntegrationData()
            }
            .onReceive(clock.bluemap) { _ in
                Task { await updateIntegrationData() }
            }
            .onReceive(clock.realtime) { _ in
                Task { await updateRealtimeIntegrationData() }
            }
            .onDisappear {
                clock.stop(timers: [.bluemap, .realtime])
            }
    }

    private func constructAnnotations() -> [any MinecraftMapBuilderContent] {
        var markers = [any MinecraftMapBuilderContent]()
        var usedIDs = Set<String>()

        for pin in file.pins {
            let marker = Marker(
                location: pin.position,
                title: pin.name,
                id: pin.id,
                color: pin.color?.swiftUIColor ?? .accent,
                systemImage: pin.icon?.resolveSFSymbol(in: .pin)
            )
            markers.append(marker)
            if let alternateIDs = pin.alternateIDs {
                usedIDs = usedIDs.union(alternateIDs)
            }
        }

        for annotation in integrationAnnotations {
            if let player = annotation as? PlayerMarker {
                markers.append(player)
            } else if let marker = annotation as? Marker {
                if usedIDs.contains(marker.id) {
                    logger.debug(
                        "📍 A marker with alternate ID '\(marker.id)' already exists. Skipping server copy."
                    )
                    continue
                }
                markers.append(marker)
            }
        }

        return markers
    }

    private func updateIntegrationData() async {
        let service = CartographyIntegrationService(serviceType: .bluemap, integrationSettings: file.integrations)
        do {
            withAnimation {
                integrationFetchState = .refreshing
                logger.debug("📍 Attempting to refresh the map.")
            }
            let result: BluemapResults? = try await service.sync(dimension: dimension)
            guard let result else {
                withAnimation {
                    integrationFetchState = .error("Response returned empty.")
                    logger.error("📍 The response returned empty.")
                }
                return
            }
            integrationData[.bluemap] = result
            withAnimation {
                let lastUpdate = Date.now
                integrationFetchState = .success(lastUpdate)
                logger.debug("📍 The map was updated successfully at \(lastUpdate)")
            }
        } catch CartographyIntegrationService.ServiceError.integrationDisabled {
            withAnimation {
                integrationFetchState = .cancelled
                logger.debug("📍 Map refresh was cancelled.")
            }
        } catch {
            withAnimation {
                integrationFetchState = .error(error.localizedDescription)
                logger.error("📍 An error occurred when updating the map: \(error.localizedDescription)")
            }
        }
    }

    private func updateRealtimeIntegrationData() async {
        guard file.integrations.enabled else { return }
        logger.debug("📍 Attempting to fetch realtime data.")
        let service = CartographyIntegrationService(serviceType: .bluemap, integrationSettings: file.integrations)
        do {
            let result: BluemapResults? = try await service.sync(
                dimension: dimension,
                syncType: .realtime
            )
            guard let result else { return }
            if let currentData = integrationData[.bluemap] as? BluemapResults {
                integrationData[.bluemap] = result.merged(with: currentData)
            }
        } catch {
            logger.error("📍 An error occurred when fetching the realtime data: \(error.localizedDescription)")
        }
    }
}
