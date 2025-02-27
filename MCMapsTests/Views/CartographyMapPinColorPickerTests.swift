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
    @Test func viewInitializes() throws {
        let color = Binding<CartographyMapPin.Color?>(wrappedValue: .blue)
        let picker = CartographyMapPinColorPicker(color: color)
        let sut = try picker.inspect().implicitAnyView()
        
        #expect(!sut.isAbsent)
        for color in CartographyMapPin.Color.allCases {
            let accessibilityLabel = String(describing: color).localizedCapitalized
            let button = try sut.find(viewWithTag: color)
            #expect(try button.accessibilityLabel().string() == accessibilityLabel)
        }
    }

    @Test(arguments: CartographyMapPin.Color.allCases)
    func viewUpdatesSelection(expectedColor: CartographyMapPin.Color) throws {
        let color = Binding<CartographyMapPin.Color?>(wrappedValue: nil)
        let picker = CartographyMapPinColorPicker(color: color)
        let sut = try picker.inspect().implicitAnyView()

        let button = try sut.find(viewWithTag: expectedColor)
        try button.button().tap()
        #expect(color.wrappedValue == expectedColor)
    }
}
