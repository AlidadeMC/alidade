//
//  TestFixtures.swift
//  AlidadeUI
//
//  Created by Marquis Kurt on 24-05-2025.
//

import SwiftUI
import Testing

/// A short typealias to represent any error.
///
/// Intended to be used with `#expect(throws:)` to verify _any_ error is thrown.
typealias AnyError = any Error

extension Tag {
    /// A tag that refers to any views containing chips.
    @Tag static var chips: Self

    /// A tag that refers to any views containing finite color pickers.
    @Tag static var finiteColorPicker: Self

    /// A tag that refers to any views containing inline banners.
    @Tag static var inlineBanner: Self

    /// A tag that refers to any views containing named locations.
    @Tag static var namedLocation: Self
}

/// Run a test that is known to break under the Red Window redesign.
func withBreakingRedWindow(
    comment: Comment? = nil, sourceLocation: SourceLocation = #_sourceLocation, try closure: () throws -> Void
) rethrows {
    #if RED_WINDOW
        withKnownIssue(comment, isIntermittent: true, sourceLocation: sourceLocation, closure)
    #else
        #expect(throws: Never.self, sourceLocation: sourceLocation) {
            try closure()
        }
    #endif
}
