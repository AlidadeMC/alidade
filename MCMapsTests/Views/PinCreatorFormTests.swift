//
//  PinCreatorFormTests.swift
//  MCMaps
//
//  Created by Marquis Kurt on 09-02-2025.
//

import SwiftUI
import Testing
import ViewInspector

@testable import Alidade

@MainActor
struct PinCreatorFormTests {
    @Test func formInitialize() throws {
        let form = PinCreatorForm(location: .zero) { newPin in }
        let hooks = form.testHooks
        #expect(hooks.name == "Pin")
        #expect(hooks.color == .blue)
        #expect(hooks.location == .zero)
    }

    @Test func formSubmit() throws {
        let form =
            PinCreatorForm(location: .zero) { newPin in
                #expect(newPin == .init(position: .zero, name: "Pin", color: .blue))
            }
        let sut = try form.inspect().implicitAnyView()
        let doneButton = try sut.find(button: "Create")
        try doneButton.tap()
    }

    @Test func formCancel() throws {
        let form =
            PinCreatorForm(location: .zero) { newPin in
                Issue.record("Completion handler should not be executing here.")
            }
        let sut = try form.inspect().implicitAnyView()
        let doneButton = try sut.find(button: "Cancel")
        try doneButton.tap()
    }
}
