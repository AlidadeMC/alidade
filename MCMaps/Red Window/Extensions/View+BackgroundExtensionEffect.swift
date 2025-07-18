//
//  View+BackgroundExtensionEffect.swift
//  MCMaps
//
//  Created by Marquis Kurt on 18-06-2025.
//

import SwiftUI

extension View {
    /// Adds a background extension effect to the selected view if the effect is available.
    func backgroundExtensionEffectIfAvailable() -> some View {
        #if RED_WINDOW
        Group {
            if #available(macOS 16, iOS 19, *) {
                self.backgroundExtensionEffect()
            } else {
                self
            }
        }
        #else
        self
        #endif
    }

    /// Adds a glass effect to the selected view if available.
    func glassEffectIfAvailable() -> some View {
        #if RED_WINDOW
        Group {
            if #available(iOS 19, macOS 19, *) {
                self.glassEffect()
            } else {
                self
            }
        }
        #else
        self
        #endif
    }
}
