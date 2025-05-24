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

        let view = try textField.inspect()
        #expect(!view.isAbsent)
    }

    @Test(.tags(.chips))
    func viewModifier() throws {
        let chips = Binding(wrappedValue: Set<String>())
        let textField = ChipTextField("Foo", chips: chips)
            .chipTextFieldStyle(.roundedBorder)
        
        #expect(textField.chips == [])
        #expect(textField.title == "Foo")
        #expect(textField.submitWithSpaces == true)
        #expect(textField.style == .roundedBorder)
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
        try view.scrollView().callOnSubmit()

        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            #expect(textField.chips == ["Augenwaldburg"])
        }
    }
}
