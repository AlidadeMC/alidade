//
//  SearchedStructuresSectionTests.swift
//  MCMaps
//
//  Created by Marquis Kurt on 27-02-2025.
//

import AlidadeUI
import MCMap
import SwiftUI
import Testchamber
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
            pins: [CartographyMapPin(named: "Mineshaft", at: .zero)],
            viewModel: viewModel,
            file: file) { location in
                #expect(location.name == "Mineshaft")
                #expect(location.position == .zero)
            }
        let sut = try section.inspect()

        let button = try sut.section().group(0).forEach(0).view(NamedLocationView.self, 0)
        Testchamber.assumeRedWindowBreaks {
            try button.callOnTapGesture()
        }
    }
}
