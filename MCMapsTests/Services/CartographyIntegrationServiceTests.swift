//
//  CartographyIntegrationServiceTests.swift
//  MCMaps
//
//  Created by Marquis Kurt on 05-08-2025.
//

import Foundation
import MCMap
import Testing

@testable import Alidade

struct CartographyIntegrationServiceTests {
    let service = MockNetworkServicable()
    let sampleFile = CartographyMapFile(withManifest: .sampleFile)

    var integration: CartographyMapFile.Integrations {
        var original = sampleFile.integrations
        original.bluemap.baseURL = "bluemap.augenwaldburg.tld"
        original.bluemap.enabled = true
        original.bluemap.realtime = true
        original.bluemap.mapping.overworld = "world"
        return original
    }

    @Test func syncNoopWhenDisabled() async throws {
        var disabled = integration
        disabled.bluemap.enabled = false

        let service = CartographyIntegrationService(
            serviceType: .bluemap,
            integrationSettings: disabled,
            session: service
        )

        await #expect(throws: CartographyIntegrationService.ServiceError.integrationDisabled) {
            let _: BluemapResults? = try await service.sync(dimension: .overworld)
        }
    }

    @Test func bluemapRegularSync() async throws {
        let service = CartographyIntegrationService(
            serviceType: .bluemap,
            integrationSettings: integration,
            session: service
        )
        let response: BluemapResults? = try await service.sync(dimension: .overworld, syncType: .regular)
        #expect(response?.isEmpty == false)
    }

    @Test func bluemapRealtimeSync() async throws {
        let service = CartographyIntegrationService(
            serviceType: .bluemap,
            integrationSettings: integration,
            session: service
        )
        let response: BluemapResults? = try await service.sync(dimension: .overworld, syncType: .realtime)
        #expect(response?.isEmpty == false)
        #expect(response?.markers == nil)
        #expect(response?.players != nil)
    }
}
