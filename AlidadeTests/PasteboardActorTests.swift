//
//  PasteboardActorTests.swift
//  MCMaps
//
//  Created by Marquis Kurt on 12-08-2025.
//

#if canImport(AppKit)
import AppKit
#endif

#if canImport(UIKit)
import UIKit
#endif

import Foundation
import Testing

@testable import Alidade

struct PasteboardActorTests {
    @Test func pasteboardCopiesString() async throws {
        let pasteboard = PasteboardActor(source: .custom)
        await pasteboard.copy("foo")

        #expect(await pasteboard.getStringContents() == "foo")
    }

    @Test func pasteboardCopiesCoordinate() async throws {
        let pasteboard = PasteboardActor(source: .custom)
        await pasteboard.copy(CGPoint.zero)

        #expect(await pasteboard.getStringContents() == "0, 0")
    }
}
