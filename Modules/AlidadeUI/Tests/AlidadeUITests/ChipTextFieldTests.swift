//
//  ChipTextFieldTests.swift
//  AlidadeUI
//
//  Created by Marquis Kurt on 23-05-2025.
//

import SwiftUI
import Testing
import ViewInspector

@testable import AlidadeUI

@MainActor
struct ChipTextFieldTests {
    @Test(.tags(.chips))
    func viewInit() throws {
        let chips = Binding(wrappedValue: Set<String>())
        let textField = ChipTextField("Foo", chips: chips)

        #expect(textField.chips == [])
        #expect(textField.title == "Foo")
        #expect(textField.submitWithSpaces == true)
        #expect(textField.prompt == "")

        let view = try textField.inspect()
        #expect(!view.isAbsent)
    }

    @Test(.tags(.chips))
    func viewInitPrompt() throws {
        let chips = Binding(wrappedValue: Set<String>())
        let textField = ChipTextField("Foo", chips: chips, prompt: "Write a tag...")
            .chipPlacement(.trailing)

        #expect(textField.chips == [])
        #expect(textField.title == "Foo")
        #expect(textField.submitWithSpaces == true)
        #expect(textField.prompt == "Write a tag...")
    }

    @Test(.tags(.chips))
    func viewLayoutStyle() throws {
        let chips = Binding(wrappedValue: Set<String>())
        let textField = ChipTextField("Foo", chips: chips)
            .chipTextFieldStyle(.roundedBorder)

        #expect(textField.chips == [])
        #expect(textField.title == "Foo")
        #expect(textField.submitWithSpaces == true)
        #expect(textField.prompt == "")
        #expect(textField.style == .roundedBorder)
    }

    @Test(.tags(.chips))
    func viewLayoutPlacement() throws {
        let chips = Binding(wrappedValue: Set<String>())
        let textField = ChipTextField("Foo", chips: chips)
            .chipPlacement(.trailing)

        #expect(textField.chips == [])
        #expect(textField.title == "Foo")
        #expect(textField.submitWithSpaces == true)
        #expect(textField.prompt == "")
        #expect(textField.chipPlacement == .trailing)
    }

    @Test(.tags(.chips))
    func viewLayoutTitleStyle() throws {
        let chips = Binding(wrappedValue: Set<String>())
        let textField = ChipTextField("Foo", chips: chips)
            .titleStyle(.muted)

        #expect(textField.chips == [])
        #expect(textField.title == "Foo")
        #expect(textField.submitWithSpaces == true)
        #expect(textField.prompt == "")
        #expect(textField.titleStyle == .muted)
    }

    @Test(.tags(.chips))
    func submitIntoTagViaSpaces() throws {
        let chips = Binding(wrappedValue: Set<String>())
        let textField = ChipTextField("Foo", chips: chips)

        textField.updateText(to: "Augenwaldburg ")
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            #expect(textField.chips == ["Augenwaldburg"])
        }
    }

    @Test(.tags(.chips))
    func submitIntoTag() throws {
        let chips = Binding(wrappedValue: Set<String>())
        let textField = ChipTextField("Foo", chips: chips)

        textField.updateText(to: "Augenwaldburg")

        let view = try textField.inspect()
        try view.hStack().callOnSubmit()

        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            #expect(textField.chips == ["Augenwaldburg"])
        }
    }
}
