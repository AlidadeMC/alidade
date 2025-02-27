//
//  TestFixtures.swift
//  MCMaps
//
//  Created by Marquis Kurt on 27-02-2025.
//

import Testing

extension Tag {
    /// A tag for tests that work directly with a document or other I/O.
    @Tag static var document: Self

    /// A tag for tests that work with view models.
    @Tag static var viewModel: Self
}

enum TargetPlatform {
    case macOS
    case iOS
}

func platform(is target: TargetPlatform) -> Bool {
    #if os(macOS)
    return target == .macOS
    #else
    return target == .iOS
    #endif
}
