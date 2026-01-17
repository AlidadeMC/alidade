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
    /// An enumeration of the clock timers the clock handles.
    enum ClockTimer: Equatable, Hashable, CustomStringConvertible {
        /// A realtime timer used to publish realtime data.
        case realtime

        /// A timer used to publish Bluemap data.
        case bluemap

        var description: String {
            switch self {
            case .realtime: "Realtime"
            case .bluemap: "Bluemap"
            }
        }
    }

    /// A timer used to publish realtime data.
    var realtime: Publishers.Autoconnect<Timer.TimerPublisher>

    /// A timer used to publish data when connecting to the Bluemap service.
    ///
    /// If the service is disabled or hasn't been set up with ``setup(timer:at:)``, this will almost never fire.
    var bluemap: Publishers.Autoconnect<Timer.TimerPublisher>

    private let realtimeTimer = Timer.publish(every: 0.5, on: .main, in: .common)
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
    /// - Parameter timer: The integration to set up a timer for.
    /// - Parameter timeInterval: The duration of the timer before a new event is published.
    func setup(timer: ClockTimer, at timeInterval: TimeInterval) {
        switch timer {
        case .bluemap:
            bluemapTimer?.connect().cancel()
            bluemapTimer = Timer.publish(every: timeInterval, on: .main, in: .common)
        case .realtime:
            logger.error("⏰ The realtime timer cannot be set up manually.")
        }
    }

    /// Start the specified timer.
    /// - Parameter timer: The timer to start.
    func start(timer: ClockTimer) {
        switch timer {
        case .bluemap:
            guard let bluemapTimer else {
                logger.error("⏰ The Bluemap timer wasn't set up.")
                return
            }
            bluemap = bluemapTimer.autoconnect()
        case .realtime:
            realtime = realtimeTimer.autoconnect()
        }
        logger.debug("⏰ \(timer) timer was started.")
    }

    /// Start the specified timers.
    /// - Parameter timers: The timer to start.
    func start(timers: [ClockTimer]) {
        for timer in timers {
            start(timer: timer)
        }
    }

    /// Stop the specified timer.
    /// - Parameter timer: The timer to stop.
    func stop(timer: ClockTimer) {
        switch timer {
        case .bluemap:
            bluemap.upstream.connect().cancel()
        case .realtime:
            realtime.upstream.connect().cancel()
        }
        logger.debug("⏰ \(timer) timer was stopped.")
    }

    /// Stop the specified timers.
    /// - Parameter timers: The timers to stop.
    func stop(timers: [ClockTimer]) {
        for timer in timers {
            stop(timer: timer)
        }
    }
}
