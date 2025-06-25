//
//  CartographyMapPinDetailViewTests.swift
//  MCMaps
//
//  Created by Marquis Kurt on 27-02-2025.
//

import MCMapFormat
import SwiftUI
import Testing
import ViewInspector

@testable import Alidade

@MainActor
struct CartographyMapPinDetailViewTests {
    @Test(.tags(.legacyUI))
    func viewInitializes() throws {
        let file = Binding(wrappedValue: CartographyMapFile(withManifest: .sampleFile))
        let viewModel = CartographyPinViewModel(file: file, index: 0)
        let view = CartographyMapPinDetailView(viewModel: viewModel)
        let sut = try view.inspect()

        #expect(!sut.isAbsent)
        #expect(view.testHooks.photoItem == nil)
        #expect(view.testHooks.photoToUpdate == nil)
    }

    @Test(.enabled(if: platform(is: .macOS)), .tags(.legacyUI))
    func savePanelOpens() throws {
        let file = Binding(wrappedValue: CartographyMapFile(withManifest: .sampleFile))
        let viewModel = CartographyPinViewModel(file: file, index: 0)
        let view = CartographyMapPinDetailView(viewModel: viewModel)

        #if os(macOS)
        Task {
            let panel = await view.testHooks.openSavePanel()
            #expect(panel.canChooseDirectories == false)
            #expect(panel.allowedContentTypes == [.image])
            #expect(
                panel.directoryURL == FileManager.default.homeDirectoryForCurrentUser.appending(path: "Pictures"))
        }
        #endif
    }
}
