// The Swift Programming Language
// https://docs.swift.org/swift-book

import SwiftUI

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
}
