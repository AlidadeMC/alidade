// The Swift Programming Language
// https://docs.swift.org/swift-book

import SwiftUI

public struct ColorSchemeSet: Sendable, Equatable {
    public var light: Color
    public var dark: Color

    public func resolve(in environment: EnvironmentValues) -> Color {
        switch environment.colorScheme {
        case .light:
            return self.light
        case .dark:
            return self.dark
        @unknown default:
            return self.light
        }
    }

    public func resolve(with colorScheme: ColorScheme) -> Color {
        var environment = EnvironmentValues()
        environment.colorScheme = colorScheme
        return self.resolve(in: environment)
    }
}

public enum SemanticColors {
    public static let accent: Color = Color(.Brand.firewatchRed)

    public enum Pins {
        public static let accentRed = Color(.Primitive.Red._400)
        public static let accentOrange = Color(.Primitive.Orange._400)
        public static let accentYellow = Color(.Primitive.Yellow._400)
        public static let accentGreen = Color(.Primitive.Green._500)
        public static let accentBlue = Color(.Primitive.Blue._300)
        public static let accentIndigo = Color(.Primitive.Purple._400)
        public static let accentBrown = Color(.Primitive.Orange._600)
    }

    public enum DocumentLaunch {
        public static let mobileDocument = Color(.Primitive.Blue._300)
    }

    public enum Alert {
        public static let infoBackground = ColorSchemeSet(
            light: Color(.Primitive.Blue._100), dark: Color(.Primitive.Blue._700))
        public static let successBackground = ColorSchemeSet(
            light: Color(.Primitive.Green._100), dark: Color(.Primitive.Green._700))
        public static let warningBackground = ColorSchemeSet(
            light: Color(.Primitive.Yellow._100), dark: Color(.Primitive.Yellow._700))
        public static let errorBackground = ColorSchemeSet(
            light: Color(.Primitive.Red._100), dark: Color(.Primitive.Red._700))

        public static let infoForeground = ColorSchemeSet(
            light: Color(.Primitive.Blue._600), dark: Color(.Primitive.Blue._200))
        public static let successForeground = ColorSchemeSet(
            light: Color(.Primitive.Green._600), dark: Color(.Primitive.Green._200))
        public static let warningForeground = ColorSchemeSet(
            light: Color(.Primitive.Yellow._600), dark: Color(.Primitive.Yellow._200))
        public static let errorForeground = ColorSchemeSet(
            light: Color(.Primitive.Red._600), dark: Color(.Primitive.Red._200))
    }
}
