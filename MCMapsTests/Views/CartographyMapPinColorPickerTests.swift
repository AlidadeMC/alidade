//
//  CartographyMapPinColorPickerTests.swift
//  MCMaps
//
//  Created by Marquis Kurt on 27-02-2025.
//

import SwiftUI
import Testing
import ViewInspector

@testable import Alidade

@MainActor
struct CartographyMapPinColorPickerTests {
    @Test(.disabled(), arguments: MCMapManifestPin.Color.allCases)
    func viewUpdatesSelection(expectedColor: MCMapManifestPin.Color) throws {
        let color = Binding<MCMapManifestPin.Color?>(wrappedValue: nil)
        let picker = CartographyMapPinColorPicker(color: color)
        let sut = try picker.inspect()

        let button = try sut.find(viewWithTag: expectedColor.swiftUIColor)
        try button.button().tap()

        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            #expect(color.wrappedValue == expectedColor)
        }
    }
}
