//
//  View+BackgroundExtensionEffect.swift
//  MCMaps
//
//  Created by Marquis Kurt on 18-06-2025.
//

import SwiftUI

extension View {
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
}
