//
//  DocumentLaunchViewTests.swift
//  MCMaps
//
//  Created by Marquis Kurt on 01-03-2025.
//

import SwiftUI
import Testing
import ViewInspector

@testable import Alidade

@MainActor
struct DocumentLaunchViewTests {
    @Test(.enabled(if: platform(is: .iOS)))
    func sceneInitializationMobile() throws {
        let proxyMap = Binding(wrappedValue: CartographyMap.sampleFile)
        let displayCreationWindow = Binding(wrappedValue: false)
        let launchViewModel = DocumentLaunchViewModel(displayCreationWindow: displayCreationWindow, proxyMap: proxyMap)
        let launchView = DocumentLaunchView(viewModel: launchViewModel)

        #if os(iOS)
            #expect(launchView.testHooks.creationContinuation == nil)
        #else
            Issue.record("This test shouldn't run on macOS.")
        #endif
    }
}
