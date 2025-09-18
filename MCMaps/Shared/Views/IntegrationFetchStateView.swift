//
//  IntegrationFetchStateView.swift
//  MCMaps
//
//  Created by Marquis Kurt on 13-07-2025.
//

import SwiftUI

/// An enumeration of the various states a view that fetches data from integrations can be in.
enum IntegrationFetchState: Equatable {
    /// The initial state.
    case initial

    /// The view is refreshing the current state, fetching new data.
    case refreshing

    /// The fetching operating was cancelled.
    case cancelled

    /// The fetching of new data was successful.
    /// - Parameter updateDate: When the update succeeded.
    case success(Date)

    /// An error occurred when fetching the data.
    /// - Parameter error: The error that occurred.
    case error(String)
}

/// A view that displays an integration fetch state.
///
/// This is typically used as a status bar item to display the current state for a view that is actively fetching data.
struct IntegrationFetchStateView: View {
    /// The current state to represent in the view.
    var state: IntegrationFetchState

    private var title: String {
        switch state {
        case .initial:
            return String(localized: "Initial")
        case .refreshing:
            return String(localized: "Syncing...")
        case .cancelled:
            return String(localized: "Integrations disabled")
        case .success:
            return String(localized: "Synced")
        case .error:
            return String(localized: "Sync failed")
        }
    }

    private var symbol: String {
        switch state {
        case .initial, .refreshing:
            "arrow.down.circle.dotted"
        case .cancelled:
            "network.slash"
        case .success:
            "checkmark.circle"
        case .error:
            "exclamationmark.circle"
        }
    }

    private var help: String {
        switch state {
        case .initial, .refreshing, .cancelled:
            return ""
        case .success(let date):
            return String(localized: "Last sync: \(date.formatted(.dateTime))")
        case .error(let error):
            return error
        }
    }

    var body: some View {
        OrnamentBadge {
            Label(title, systemImage: symbol)
            .padding(1)
            .padding(.horizontal, 4)
            .padding(.vertical, 2)
        }
        .contentTransition(.symbolEffect(.replace))
        .help(help)
    }
}

private struct OrnamentBadge<Content: View>: View {
    var content: () -> Content

    var body: some View {
        Group {
            if #available(macOS 16, iOS 19, *) {
                content()
                    .glassEffect()
            } else {
                content()
                    .background(Capsule().fill(.thinMaterial))
            }
        }
    }
}
