//
//  View+IfModifier.swift
//  MCMaps
//
//  Created by Marquis Kurt on 23-02-2025.
//

import SwiftUI

extension View {
    @ViewBuilder
    func `if`<Content: View>(_ condition: Bool, apply transform: (Self) -> Content) -> some View {
        if condition {
            transform(self)
        } else {
            self
        }
    }
}
