//
//  TestFixtures.swift
//  AlidadeUI
//
//  Created by Marquis Kurt on 24-05-2025.
//

import SwiftUI
import Testing

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
