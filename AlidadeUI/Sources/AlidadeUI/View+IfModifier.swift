//
//  View+IfModifier.swift
//  AlidadeUI
//
//  Created by Marquis Kurt on 24-05-2025.
//

import SwiftUI

public extension View {
    /// Conditionally apply a modifier based on a given property.
    ///
    /// This is typically used to handle modifiers that cannot be easily checked with a ternary condition:
    ///
    /// ```swift
    /// SomeMagicView()
    ///     .if(shouldBeHidden) { hidingView in
    ///         hidingView.hidden()
    ///     }
    /// ```
    ///
    /// > Tip: Wherever possible, try to handle conditional checking with a ternary operator or equivalent. This
    /// > modifier will replace views entirely rather that apply regular modifiers to them, so it may result in
    /// > additional resource usage.
    ///
    /// - Parameter condition: The condition that determine whether the changes should be applied.
    /// - Parameter transform: The transformation closure that will conditionally apply modifiers.
    @ViewBuilder
    func `if`<Content: View>(_ condition: Bool, apply transform: (Self) -> Content) -> some View {
        if condition {
            transform(self)
        } else {
            self
        }
    }
}
