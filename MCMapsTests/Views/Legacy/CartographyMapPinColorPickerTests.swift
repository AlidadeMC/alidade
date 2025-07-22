//
//  CartographyMapPinColorPickerTests.swift
//  MCMaps
//
//  Created by Marquis Kurt on 27-02-2025.
//

import MCMap
import SwiftUI
import Testing
import ViewInspector

@testable import Alidade

@MainActor
struct CartographyMapPinColorPickerTests {
    @Test(.disabled(), .tags(.legacyUI), arguments: CartographyMapPin.Color.allCases)
    func viewUpdatesSelection(expectedColor: CartographyMapPin.Color) throws {
        let color = Binding<CartographyMapPin.Color?>(wrappedValue: nil)
        let picker = CartographyMapPinColorPicker(color: color)
        let sut = try picker.inspect()

        let button = try sut.find(viewWithTag: expectedColor.swiftUIColor)
        try button.button().tap()

        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            #expect(color.wrappedValue == expectedColor)
        }
    }
}
