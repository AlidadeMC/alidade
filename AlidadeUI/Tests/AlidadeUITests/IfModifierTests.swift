//
//  IfModifierTests.swift
//  AlidadeUI
//
//  Created by Marquis Kurt on 24-05-2025.
//

import SwiftUI
import Testing
import ViewInspector

@testable import AlidadeUI

@MainActor
struct IfModifierTests {
    @Test func conditionalModifierApplies() throws {
        var shouldSwitch = false
        let myText = Text("Hello, world!")
            .if(shouldSwitch) { view in
                view.font(.headline)
            }
        
        let sut = try myText.inspect()
        #expect(throws: (any Error).self) {
            try sut.text().attributes().font()
        }

        // Switch the flag and "reload" the view...
        shouldSwitch = true
        let myAltText = Text("Hello, world!")
            .if(shouldSwitch) { view in
                view.font(.headline)
            }
        let sut2 = try myAltText.inspect()
        #expect(try sut2.text().attributes().font() == .headline)
    }
}
