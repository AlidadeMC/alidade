//
//  AdaptableSidebarSheetViewTests.swift
//  MCMaps
//
//  Created by Marquis Kurt on 09-02-2025.
//

import SwiftUI
import Testing
import ViewInspector

@testable import Alidade

#if os(iOS)
    @MainActor
    struct AdaptableSidebarSheetViewTests {
        @Test func viewInitialize() throws {
            let content = {
                return Text("Background!")
            }
            let sheet = {
                return Text("Foreground!")
            }
            let view = AdaptableSidebarSheetView(content: content, sheet: sheet)
            let hooks = view.testHooks

            #expect(hooks.sheetDisplayedInternally == false)
            #expect(hooks.preferredSidebarWidthFraction == 0.317)

            let contentExpectSut = try content().inspect()
            let contentActualSut = try view.content().inspect()
            #expect(try contentActualSut.text().string() == contentExpectSut.text().string())
        }

        @Test func viewInitializeWithBinding() throws {
            let isPresented = Binding<Bool>(wrappedValue: false)
            let content = {
                return Text("Background!")
            }
            let sheet = {
                return Text("Foreground!")
            }
            let view = AdaptableSidebarSheetView(isPresented: isPresented, content: content, sheet: sheet)
            let hooks = view.testHooks

            #expect(hooks.sheetDisplayedInternally == isPresented.wrappedValue)
            #expect(hooks.preferredSidebarWidthFraction == 0.317)

            let contentExpectSut = try content().inspect()
            let contentActualSut = try view.content().inspect()
            #expect(try contentActualSut.text().string() == contentExpectSut.text().string())
        }
    }
#endif
