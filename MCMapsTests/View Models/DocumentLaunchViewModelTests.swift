//
//  DocumentLaunchViewModelTests.swift
//  MCMaps
//
//  Created by Marquis Kurt on 15-03-2025.
//

import MCMapFormat
import SwiftUI
import Testing

@testable import Alidade

struct DocumentLaunchViewModelTests {
    @Test(.tags(.viewModel), .enabled(if: platform(is: .macOS))) func sanitizedURL() throws {
        let proxyMap = Binding(wrappedValue: MCMapManifest.sampleFile)
        let displayCreationWindow = Binding(wrappedValue: false)
        let launchViewModel = DocumentLaunchViewModel(displayCreationWindow: displayCreationWindow, proxyMap: proxyMap)

        let url = URL(filePath: "/Users/weiss/Documents/Augenwaldburg.mcmap")
        let fileName = launchViewModel.sanitize(url: url)
        #expect(fileName == "Augenwaldburg")
    }

    @Test(.tags(.viewModel), .enabled(if: platform(is: .macOS))) func friendlyURL() throws {
        let proxyMap = Binding(wrappedValue: MCMapManifest.sampleFile)
        let displayCreationWindow = Binding(wrappedValue: false)
        let launchViewModel = DocumentLaunchViewModel(displayCreationWindow: displayCreationWindow, proxyMap: proxyMap)

        let url = URL(filePath: "/Users/weiss/Documents/Augenwaldburg.mcmap")
        let path = launchViewModel.friendlyUrl(url, for: "weiss")
        #expect(path == "~/Documents")
    }

    @Test(.tags(.viewModel), .enabled(if: platform(is: .macOS))) func urlIsInMobileDocuments() throws {
        let proxyMap = Binding(wrappedValue: MCMapManifest.sampleFile)
        let displayCreationWindow = Binding(wrappedValue: false)
        let launchViewModel = DocumentLaunchViewModel(displayCreationWindow: displayCreationWindow, proxyMap: proxyMap)

        let url = URL(filePath: "/Users/weiss/Library/Mobile Documents/com~apple~CloudDocs/Alidade/Augenwaldburg.mcmap")
        let isInCloudStorage = launchViewModel.isInMobileDocuments(url, for: "weiss")
        #expect(isInCloudStorage == true)
    }
}
