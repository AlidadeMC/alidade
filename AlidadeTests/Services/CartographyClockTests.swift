//
//  CartographyClockTests.swift
//  MCMaps
//
//  Created by Marquis Kurt on 04-08-2025.
//

import Combine
import Foundation
import Testing

@testable import Alidade

struct CartographyClockTests {
    @Test func clockInitialValues() async throws {
        let clock = CartographyClock()

        #expect(clock.realtime.upstream.interval == 0.5)
        #expect(clock.realtime.upstream.mode == .common)
        #expect(clock.realtime.upstream.runLoop == RunLoop.main)

        // Verify that we've made this timer infinite so as to never execute.
        #expect(clock.bluemap.upstream.interval == .greatestFiniteMagnitude)
    }

    @Test func clockSetup() async throws {
        let clock = CartographyClock()
        clock.setup(timer: .bluemap, at: 100)
        clock.start(timer: .bluemap)

        #expect(clock.bluemap.upstream.interval == 100)
    }

    @Test func clockDestroy() async throws {
        let clock = CartographyClock()
        clock.setup(timer: .bluemap, at: 100)
        clock.start(timer: .bluemap)

        try await Task.sleep(for: .seconds(1))

        clock.stop(timer: .bluemap)
    }
}
