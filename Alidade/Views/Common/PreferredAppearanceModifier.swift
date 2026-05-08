//
//  PreferredAppearanceModifier.swift
//  Alidade
//
//  Created by Marquis Kurt on 08-05-2026.
//

import SwiftUI

extension View {
    func usePreferredAppearance() -> some View {
        self.modifier(PreferredAppearanceModifier())
    }
}

private struct PreferredAppearanceModifier: ViewModifier {
    @AppStorage(UserDefaults.Keys.generalAppearance.rawValue)
    private var appearance: PreferredColorScheme = .automatic

    func body(content: Content) -> some View {
        let colorScheme = ColorScheme(preferredColorScheme: appearance)
        switch colorScheme {
        case .some(let scheme):
            content
                #if os(iOS)
                    .environment(\.colorScheme, scheme)
                #endif
                .preferredColorScheme(colorScheme)
                .animation(.default, value: appearance)
        case nil:
            content
                .animation(.default, value: appearance)
        }
    }
}
