//
//  CartographyMapPinTests.swift
//  MCMaps
//
//  Created by Marquis Kurt on 04-02-2025.
//

import MCMap
import SwiftUI
import Testing

@testable import Alidade

struct CartographyMapPinTests {
    @Test(.tags(.document), arguments: [
        (CartographyMapPin.Color.blue, Color.blue),
        (CartographyMapPin.Color.brown, Color.brown),
        (CartographyMapPin.Color.gray, Color.gray),
        (CartographyMapPin.Color.green, Color.green),
        (CartographyMapPin.Color.indigo, Color.indigo),
        (CartographyMapPin.Color.orange, Color.orange),
        (CartographyMapPin.Color.pink, Color.pink),
        (CartographyMapPin.Color.red, Color.red),
        (CartographyMapPin.Color.yellow, Color.yellow),
    ])
    func pinColorMapsToSwiftUI(pinColor: CartographyMapPin.Color, swiftUIColor: Color) async throws {
        #expect(pinColor.swiftUIColor == swiftUIColor)
    }
}
