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
        let launchView = DocumentLaunchView(displayCreationWindow: displayCreationWindow, proxyMap: proxyMap)

        #if os(iOS)
            #expect(launchView.testHooks.creationContinuation == nil)
        #else
            Issue.record("This test shouldn't run on macOS.")
        #endif
    }

    @Test(.enabled(if: platform(is: .macOS)))
    func sanitizedURL() throws {
        let proxyMap = Binding(wrappedValue: CartographyMap.sampleFile)
        let displayCreationWindow = Binding(wrappedValue: false)
        let launchView = DocumentLaunchView(displayCreationWindow: displayCreationWindow, proxyMap: proxyMap)

        let url = URL(filePath: "/Users/weiss/Documents/Augenwaldburg.mcmap")
        #if os(macOS)
            let fileName = launchView.testHooks.sanitize(url: url)
            #expect(fileName == "Augenwaldburg")
        #else
            Issue.record("This test shouldn't run on iOS.")
        #endif
    }

    @Test(.enabled(if: platform(is: .macOS)))
    func friendlyURL() throws {
        let proxyMap = Binding(wrappedValue: CartographyMap.sampleFile)
        let displayCreationWindow = Binding(wrappedValue: false)
        let launchView = DocumentLaunchView(displayCreationWindow: displayCreationWindow, proxyMap: proxyMap)

        let url = URL(filePath: "/Users/weiss/Documents/Augenwaldburg.mcmap")
        #if os(macOS)
            let path = launchView.testHooks.friendlyUrl(url, for: "weiss")
            #expect(path == "~/Documents")
        #else
            Issue.record("This test shouldn't run on iOS.")
        #endif
    }

    @Test(.enabled(if: platform(is: .macOS)))
    func urlIsInMobileDocuments() throws {
        let proxyMap = Binding(wrappedValue: CartographyMap.sampleFile)
        let displayCreationWindow = Binding(wrappedValue: false)
        let launchView = DocumentLaunchView(displayCreationWindow: displayCreationWindow, proxyMap: proxyMap)

        let url = URL(filePath: "/Users/weiss/Library/Mobile Documents/com~apple~CloudDocs/Alidade/Augenwaldburg.mcmap")
        #if os(macOS)
            let isInCloudStorage = launchView.testHooks.isInMobileDocuments(url, for: "weiss")
            #expect(isInCloudStorage == true)
        #else
            Issue.record("This test shouldn't run on iOS.")
        #endif
    }
}
