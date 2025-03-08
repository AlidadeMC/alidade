//
//  SearchedStructuresSectionTests.swift
//  MCMaps
//
//  Created by Marquis Kurt on 27-02-2025.
//

import SwiftUI
import Testing
import ViewInspector

@testable import Alidade

@MainActor
struct SearchedStructuresSectionTests {
    @Test func viewLayout() throws {
        let viewModel = Binding(wrappedValue: CartographyMapViewModel())
        let file = Binding(wrappedValue: CartographyMapFile(map: .sampleFile))
        let section = GroupedPinsSection(
            pins: [.init(position: .zero, name: "Mineshaft")],
            viewModel: viewModel,
            file: file) { location in
                #expect(location == .init(position: .zero, name: "Mineshaft"))
            }
        let sut = try section.inspect().implicitAnyView()

        let button = try sut.section().group(0).forEach(0).view(CartographyNamedLocationView.self, 0)
        try button.callOnTapGesture()
    }
}
