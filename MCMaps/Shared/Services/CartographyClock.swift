//
//  CartographyClock.swift
//  MCMaps
//
//  Created by Marquis Kurt on 29-07-2025.
//

import Combine
import Foundation
import os

/// A clock used to house several timers.
///
/// Maps and other parts of the interface might require a constant stream of updates based on a timer. Rather than
/// creating several timers to manage, views can create a clock and subscribe to the timers they need.
class CartographyClock {
    /// A timer used to publish realtime data.
    var realtime: Publishers.Autoconnect<Timer.TimerPublisher>

    /// A timer used to publish data when connecting to the Bluemap service.
    ///
    /// If the service is disabled or hasn't been set up with ``setupTimer(for:with:)``, this will almost never fire.
    var bluemap: Publishers.Autoconnect<Timer.TimerPublisher>

    private let realtimeTimer = Timer.publish(every: 0.250, on: .main, in: .common)
    private var bluemapTimer: Timer.TimerPublisher?
    private let stillFrame = Timer.publish(every: .greatestFiniteMagnitude, on: .main, in: .default)

    private let logger: Logger

    /// Create a clock service.
    init() {
        logger = Logger(subsystem: "net.marquiskurt.mcmaps", category: "\(CartographyClock.self)")
        realtime = realtimeTimer.autoconnect()
        bluemap = stillFrame.autoconnect()
    }

    /// Set up a timer for a corresponding service integration.
    /// - Parameter integration: The integration to set up a timer for.
    /// - Parameter timeInterval: The duration of the timer before a new event is published.
    func setupTimer(for integration: CartographyIntegrationService.ServiceType, with timeInterval: TimeInterval) {
        switch integration {
        case .bluemap:
            bluemapTimer = Timer.publish(every: timeInterval, on: .main, in: .common)
        }
    }

    /// Restart all the current timers.
    func restartTimers() {
        let still = stillFrame.autoconnect()
        realtime = realtimeTimer.autoconnect()
        bluemap = bluemapTimer?.autoconnect() ?? still
        logger.debug("⏰ Timers have been restarted.")
    }

    /// Cancel all currently running timers.
    func cancelTimers() {
        realtimeTimer.connect().cancel()
        bluemapTimer?.connect().cancel()
        stillFrame.connect().cancel()
        logger.debug("⏰ Timers have been cancelled.")
    }
}
