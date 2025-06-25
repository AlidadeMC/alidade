//
//  SearchedStructuresSectionTests.swift
//  MCMaps
//
//  Created by Marquis Kurt on 27-02-2025.
//

import AlidadeUI
import SwiftUI
import Testing
import ViewInspector

@testable import Alidade

@MainActor
struct SearchedStructuresSectionTests {
    @Test(.tags(.legacyUI))
    func viewLayout() throws {
        let viewModel = Binding(wrappedValue: CartographyMapViewModel())
        let file = Binding(wrappedValue: CartographyMapFile(withManifest: .sampleFile))
        let section = GroupedPinsSection(
            pins: [.init(position: .zero, name: "Mineshaft")],
            viewModel: viewModel,
            file: file) { location in
                #expect(location == .init(position: .zero, name: "Mineshaft"))
            }
        let sut = try section.inspect()

        let button = try sut.section().group(0).forEach(0).view(NamedLocationView.self, 0)
        try button.callOnTapGesture()
    }
}
