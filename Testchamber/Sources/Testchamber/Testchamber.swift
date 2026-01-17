// The Swift Programming Language
// https://docs.swift.org/swift-book

import Testing

/// A short typealias to represent any error.
///
/// Intended to be used with `#expect(throws:)` to verify _any_ error is thrown.
public typealias AnyError = any Error

/// An enumeration housing testing capabilities.
public enum Testchamber {
    /// An enumeration of the platforms available for testing.
    public enum Platform {
        case macOS, iOS, tvOS, watchOS, visionOS
    }

    /// Returns whether the current platform matches the expectation.
    ///
    /// This should be used in conjunction with `.enabled(if:)` to gate tests that are intended to be executed on
    /// specific platforms.
    public static func platform(is expectation: Platform) -> Bool {
        #if os(macOS)
        return expectation == .macOS
        #elseif os(iOS)
        return expectation == .iOS
        #elseif os(tvOS)
        return expectation == .tvOS
        #elseif os(watchOS)
        return expectation == .watchOS
        #elseif os(visionOS)
        return expectation == .visionOS
        #else
        return false
        #endif
    }
}
