//
//  ChipViewTests.swift
//  AlidadeUI
//
//  Created by Marquis Kurt on 24-05-2025.
//

import SwiftUI
import Testing
import ViewInspector

@testable import AlidadeUI

@MainActor
struct ChipViewTests {
    @Test(.tags(.chips))
    func viewLayout() throws {
        let chip = ChipView(text: "Foo")
        let sut = try chip.inspect()

        #expect(chip.onDelete == nil)
        
        #expect(throws: AnyError.self) {
            try sut.find(viewWithAccessibilityLabel: "Remove Chip")
        }
    }

    @Test(.tags(.chips))
    func viewLayoutWithClosure() throws {
        let chip = ChipView(text: "Foo") {
            print("Foo")
        }
        let sut = try chip.inspect()
        #expect(throws: Never.self) {
            try sut.find(viewWithAccessibilityLabel: "Remove Chip")
        }
    }
}
