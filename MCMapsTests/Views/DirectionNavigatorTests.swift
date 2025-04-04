//
//  DirectionNavigatorTests.swift
//  MCMaps
//
//  Created by Marquis Kurt on 27-02-2025.
//

import CubiomesKit
import SwiftUI
import Testing
import ViewInspector

@testable import Alidade

@MainActor
struct DirectionNavigatorTests {
    @Test(
        .disabled("Deprecated"),
        arguments: [
        ("North", Point3D<Int32>(x: 0, y: 15, z: -256)),
        ("West", Point3D<Int32>(x: -256, y: 15, z: 0)),
        ("East", Point3D<Int32>(x: 256, y: 15, z: 0)),
        ("South", Point3D<Int32>(x: 0, y: 15, z: 256)),
    ])
    func viewPressesInDirection(direction: String, position: Point3D<Int32>) throws {
        let file = CartographyMapFile(map: .sampleFile)
        let viewModel = CartographyMapViewModel()
        let navigator = DirectionNavigator(viewModel: viewModel, file: file)
        let sut = try navigator.inspect()

        #expect(!sut.isAbsent)
        let directionalButton = try sut.find(button: "Go \(direction)")
        try directionalButton.tap()
        #expect(viewModel.worldRange.position == position)
    }
}
