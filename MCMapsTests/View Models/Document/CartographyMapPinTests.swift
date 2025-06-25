//
//  CartographyMapPinTests.swift
//  MCMaps
//
//  Created by Marquis Kurt on 04-02-2025.
//

import MCMapFormat
import SwiftUI
import Testing

@testable import Alidade

struct CartographyMapPinTests {
    @Test(.tags(.document), arguments: [
        (MCMapManifestPin.Color.blue, Color.blue),
        (MCMapManifestPin.Color.brown, Color.brown),
        (MCMapManifestPin.Color.gray, Color.gray),
        (MCMapManifestPin.Color.green, Color.green),
        (MCMapManifestPin.Color.indigo, Color.indigo),
        (MCMapManifestPin.Color.orange, Color.orange),
        (MCMapManifestPin.Color.pink, Color.pink),
        (MCMapManifestPin.Color.red, Color.red),
        (MCMapManifestPin.Color.yellow, Color.yellow),
    ])
    func pinColorMapsToSwiftUI(pinColor: MCMapManifestPin.Color, swiftUIColor: Color) async throws {
        #expect(pinColor.swiftUIColor == swiftUIColor)
    }
}
