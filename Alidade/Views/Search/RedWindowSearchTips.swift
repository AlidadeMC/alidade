//
//  RedWindowSearchTips.swift
//  MCMaps
//
//  Created by Marquis Kurt on 10-08-2025.
//

import SwiftUI

struct RedWindowSearchTips: View {
    private let tips: [LocalizedStringKey] = [
        "You can filter search results by tags using the `#tag` or `tag: tag` syntax.",
        "To filter results to a specific dimension such as the nether, use the `dimension: Nether` syntax.",
        "You can search for landmarks near a specific coordinate using the `@{X, Z}` syntax.",
    ]

    @State private var randomIndex: [LocalizedStringKey].Index = 0

    var body: some View {
        Label {
            Text(tips[randomIndex])
        } icon: {
            Image(systemName: "lightbulb")
                .symbolRenderingMode(.hierarchical)
                .foregroundStyle(.teal)
        }
        .task {
            randomIndex = tips.indices.randomElement() ?? 0
        }
    }
}
