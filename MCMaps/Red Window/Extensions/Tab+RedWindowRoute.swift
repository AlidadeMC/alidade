//
//  Tab+RedWindowRoute.swift
//  MCMaps
//
//  Created by Marquis Kurt on 18-06-2025.
//

import SwiftUI

extension Tab where Value == RedWindowRoute, Label == DefaultTabLabel, Content: View {
    /// Create a tab for a route in the Red Window design.
    /// - Parameter route: The route to create a tab for.
    /// - Parameter content: The content that will be displayed when the tab is active.
    init(route: RedWindowRoute, content: () -> Content) {
        self.init(route.name, systemImage: route.symbol, value: route, content: content)
    }
}
