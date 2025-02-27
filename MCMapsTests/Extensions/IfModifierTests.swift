//
//  IfModifierTests.swift
//  MCMaps
//
//  Created by Marquis Kurt on 26-02-2025.
//

import SwiftUI
import Testing
import ViewInspector

@testable import Alidade

@MainActor
struct IfModifierTests {
    @Test func conditionalModifierApplies() throws {
        var shouldSwitch = false
        let myText = Text("Hello, world!")
            .if(shouldSwitch) { view in
                view.font(.headline)
            }
        
        let sut = try myText.inspect().implicitAnyView()
        #expect(throws: (any Error).self) {
            try sut.text().attributes().font()
        }

        // Switch the flag and "reload" the view...
        shouldSwitch = true
        let myAltText = Text("Hello, world!")
            .if(shouldSwitch) { view in
                view.font(.headline)
            }
        let sut2 = try myAltText.inspect().implicitAnyView()
        #expect(try sut2.text().attributes().font() == .headline)
    }
}
