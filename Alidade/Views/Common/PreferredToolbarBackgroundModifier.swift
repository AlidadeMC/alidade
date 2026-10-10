//
//  PreferredToolbarBackgroundModifier.swift
//  Alidade
//
//  Created by Marquis Kurt on 10-10-2026.
//

import SwiftUI

private struct PreferredToolbarBackgroundModifier: ViewModifier {
    @AppStorage(UserDefaults.Keys.generalToolbarBackgrounds.rawValue)
    private var showToolbarBackground = false

    func body(content: Content) -> some View {
        #if os(macOS)
        content
            .toolbarBackgroundVisibility(showToolbarBackground ? .visible : .hidden, for: .windowToolbar)
            .scrollEdgeEffectStyle(.soft, for: .top)
        #else
        content
            .toolbarBackgroundVisibility(showToolbarBackground ? .visible : .hidden, for: .navigationBar)
            .scrollEdgeEffectStyle(.soft, for: .top)
        #endif
    }
}

extension View {
    func usePreferredToolbarBackground() -> some View {
        self.modifier(PreferredToolbarBackgroundModifier())
    }
}
