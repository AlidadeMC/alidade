//
//  FiniteColorPickerTests.swift
//  AlidadeUI
//
//  Created by Marquis Kurt on 26-05-2025.
//

import SwiftUI
import Testing
import ViewInspector

@testable import AlidadeUI

@MainActor
struct FiniteColorPickerTests {
    static let colors = [Color.red, Color.green, Color.blue]

    @Test(.tags(.finiteColorPicker))
    func viewInitializes() throws {
        let color = Binding<Color>(wrappedValue: .blue)
        let picker = FiniteColorPicker("", selection: color, in: Self.colors)

        #expect(picker.colorStyle == .automatic)
        #expect(picker.allowCustomSelection == false)
        
        let sut = try picker.inspect()
        #expect(!sut.isAbsent)

        for (index, color) in Self.colors.enumerated() {
            let accessibilityLabel = String(describing: color).localizedCapitalized
            let buttonView = try sut.hStack().forEach(1).view(ColorChoiceButton.self, index)
            withKnownIssue(
                "Accessibility label appears to be missing",
                isIntermittent: false,
                sourceLocation: SourceLocation(
                    fileID: "AlidadeUI/FiniteColorPicker",
                    filePath: "AlidadeUI/Sources/AlidadeUI/FiniteColorPicker/FiniteColorPicker.swift",
                    line: 121,
                    column: 9)
            ) {
                let label = try buttonView.accessibilityLabel().string()
                #expect(label == accessibilityLabel)
            }
        }
    }

    @Test(.tags(.finiteColorPicker), arguments: [Color.red, Color.blue, Color.green])
    func viewUpdatesSelection(expectedColor: Color) throws {
        let color = Binding<Color>(wrappedValue: .accentColor)
        let picker = FiniteColorPicker("", selection: color, in: Self.colors)
        let sut = try picker.inspect()

        try withBreakingRedWindow {
            let button = try sut.find(viewWithTag: expectedColor)
            try button.button().tap()
            #expect(color.wrappedValue == expectedColor)
        }
    }

    @Test(.tags(.finiteColorPicker))
    func viewAllowCustomSelection() throws {
        let color = Binding<Color>(wrappedValue: .blue)
        let picker = FiniteColorPicker("", selection: color, in: Self.colors).includeCustomSelection()
        
        #expect(picker.allowCustomSelection == true)
    }

    @Test(.tags(.finiteColorPicker))
    func viewColorStyle() throws {
        let color = Binding<Color>(wrappedValue: .blue)
        let picker = FiniteColorPicker("", selection: color, in: Self.colors).colorStyle(.gradient)
        
        #expect(picker.colorStyle == .gradient)
    }
}
