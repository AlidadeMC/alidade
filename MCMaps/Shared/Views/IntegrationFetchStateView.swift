//
//  IntegrationFetchStateView.swift
//  MCMaps
//
//  Created by Marquis Kurt on 13-07-2025.
//

import SwiftUI

enum IntegrationFetchState: Equatable {
    case initial, refreshing, cancelled
    case success(Date)
    case error(String)
}

struct IntegrationFetchStateView: View {
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
    @FeatureFlagged(.redWindow) private var useRedWindowDesign

    var content: () -> Content

    var body: some View {
        content()
            .if(useRedWindowDesign) { view in
                Group {
                    #if RED_WINDOW
                        if #available(macOS 16, iOS 19, *) {
                            view.glassEffect()
                        } else {
                            view.background(Capsule().fill(.thinMaterial))
                        }
                    #endif
                }
            } `else`: { view in
                view.background(Capsule().fill(.thinMaterial))
            }
    }
}
