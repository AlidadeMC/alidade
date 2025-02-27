//
//  OrnamentViewTests.swift
//  MCMaps
//
//  Created by Marquis Kurt on 26-02-2025.
//

import SwiftUI
import Testing
import ViewInspector

@testable import Alidade

@MainActor
struct OrnamentViewTests {
    @Test func ornamentInit() throws {
        let ornament = Ornament(alignment: .bottom) {
            Text("Hi")
        }
        let sut = try ornament.inspect().implicitAnyView().group()
        #expect(try sut.flexFrame().maxHeight == .infinity)
        #expect(try sut.flexFrame().maxWidth == .infinity)
        #expect(try sut.flexFrame().alignment == .bottom)
    }

    @Test func ornamentViewHandlesTap() throws {
        let ornamentView = OrnamentedView(content: Color.red) {
            Ornament(alignment: .bottom) {
                Text("Hi")
            }
        } tappedGesture: { newView in
            #expect(newView.testHooks.displayOrnaments == false)
        }
        let sut = try ornamentView.inspect().implicitAnyView()
        try sut.zStack().background().callOnTapGesture()
    }
}
