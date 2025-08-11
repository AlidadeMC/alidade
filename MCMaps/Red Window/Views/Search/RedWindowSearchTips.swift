//
//  RedWindowSearchTips.swift
//  MCMaps
//
//  Created by Marquis Kurt on 10-08-2025.
//

import SwiftUI

struct RedWindowSearchTips: View {
    private let tips: [LocalizedStringKey] = [
        "Use the `@{0,0}` syntax to filter search results near a specific coordinate.",
        "Type the name of a tag to filter search results by that tag."
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
