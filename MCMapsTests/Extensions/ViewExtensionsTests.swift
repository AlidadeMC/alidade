//
//  ViewExtensionsTests.swift
//  MCMaps
//
//  Created by Marquis Kurt on 05-08-2025.
//

import SwiftUI
import Testchamber
import Testing
import ViewInspector

@testable import Alidade

extension InspectableView {
    // NOTE(alicerunsonfedora): This is a pretty stupid fucking hack, but this is the only real way I can guarantee
    // that I can see whether the specified modifier exists for now, because the modifier itself is private.
    //
    // Please, for Renzo's sake, PLEASE USE THE `.modifier(viewType:)` method wherever possible!
    func containsModifier(named name: String) -> Bool {
        let description = String(describing: self)
        return description.contains(name)
    }
}

@MainActor
struct ViewExtensionsTests {
    @Test func applyGlassEffectWhenAvailable() throws {
        let rootView = Text("Hello, world!")
            .glassEffectIfAvailable()

        let sut = try rootView.inspect()
        #expect(!sut.isAbsent)


        let textView = try sut.group().find(text: "Hello, world!")
        if #available(iOS 19, macOS 16, *) {
            #expect(textView.containsModifier(named: "GlassEffectModifier"))
        } else {
            #expect(!textView.containsModifier(named: "GlassEffectModifier"))
        }
    }

    @Test func applyBackgroundExtensionEffectWhenAvailable() throws {
        let rootView = Text("Hello, world!")
            .backgroundExtensionEffectIfAvailable()

        let sut = try rootView.inspect()
        #expect(!sut.isAbsent)


        let textView = try sut.group().find(text: "Hello, world!")
        if #available(iOS 19, macOS 16, *) {
            #expect(textView.containsModifier(named: "BackgroundExtensionViewModifier"))
        } else {
            #expect(!textView.containsModifier(named: "BackgroundExtensionViewModifier"))
        }
    }
}


