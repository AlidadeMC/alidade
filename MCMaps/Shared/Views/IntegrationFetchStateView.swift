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

    var body: some View {
        Group {
            switch state {
            case .initial, .cancelled:
                EmptyView()
            case .refreshing:
                Label {
                    Text("Syncing...")
                } icon: {
                    ProgressView()
                }
                .padding(1)
                .padding(.horizontal, 4)
                .padding(.vertical, 2)
                .glassEffectIfAvailable()
            case .success(let date):
                HStack {
                    Label(
                        "Synced: \(date.formatted(date: .abbreviated, time: .shortened))",
                        systemImage: "checkmark.circle"
                    )
                }
                .padding(1)
                .padding(.horizontal, 4)
                .padding(.vertical, 2)
                .glassEffectIfAvailable()
            case .error:
                Label("Sync failed", systemImage: "exclamationmark.circle")
                    .padding(1)
                    .padding(.horizontal, 4)
                    .padding(.vertical, 2)
                    .glassEffectIfAvailable()
            }
        }
        .contentTransition(.symbolEffect(.replace))
    }
}
