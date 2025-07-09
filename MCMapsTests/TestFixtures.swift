//
//  TestFixtures.swift
//  MCMaps
//
//  Created by Marquis Kurt on 27-02-2025.
//

import Testchamber
import Testing

extension Tag {
    /// A tag for tests that work directly with a document or other I/O.
    @Tag static var document: Self

    /// A tag for tests that work with view models.
    @Tag static var viewModel: Self

    /// A tag for tests under the legacy user interface.
    @Tag static var legacyUI: Self

    /// A tag for tests under the Red Window user interface.
    @Tag static var redWindow: Self
}
