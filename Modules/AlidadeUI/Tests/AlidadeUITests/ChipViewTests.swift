//
//  ChipViewTests.swift
//  AlidadeUI
//
//  Created by Marquis Kurt on 24-05-2025.
//

import SwiftUI
import Testchamber
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
}
