//
//  CartographyMapViewModelTests.swift
//  MCMaps
//
//  Created by Marquis Kurt on 04-02-2025.
//

import CubiomesKit
import MCMap
import SwiftUI
import Testchamber
import Testing

@testable import Alidade

@MainActor
struct CartographyMapViewModelTests {
    typealias SizeClass = UserInterfaceSizeClass
    typealias Coordinate = Point3D<Int32>

    @Test(.timeLimit(.minutes(1)), .tags(.viewModel, .legacyUI))
    func viewModelInit() throws {
        let viewModel = CartographyMapViewModel()
        #expect(viewModel.currentRoute == nil)
        #expect(viewModel.displayCurrentRouteModally.wrappedValue == false)
        #expect(viewModel.searchQuery.isEmpty)
        #expect(viewModel.worldDimension == .overworld)
        #expect(viewModel.worldRange.origin == Coordinate(x: 0, y: 15, z: 0))
        #expect(viewModel.worldRange.size == MinecraftWorldRect.Size(length: 256, width: 256, height: 1))
    }

    @Test(.timeLimit(.minutes(1)), .tags(.viewModel, .legacyUI))
    func viewModelPositionLabel() throws {
        let viewModel = CartographyMapViewModel()
        #expect(viewModel.positionLabel == "X: 0, Z: 0")

//        await MainActor.run {
            viewModel.worldRange.origin = .init(cgPoint: CGPoint(x: 1847, y: 1847))
//        }

        #expect(viewModel.positionLabel == "X: 1847, Z: 1847")
    }

    @Test(.timeLimit(.minutes(1)), .tags(.viewModel, .legacyUI))
    func viewModelGoesToPosition() throws {
        let viewModel = CartographyMapViewModel()
        let file = CartographyMapFile(withManifest: .sampleFile)
        #expect(viewModel.worldRange.origin == .init(x: 0, y: 15, z: 0))

        viewModel.go(to: .init(x: 1847, y: 1847), relativeTo: file)
        #expect(viewModel.worldRange.origin == .init(x: 1847, y: 15, z: 1847))
    }

    @Test(.timeLimit(.minutes(1)), .tags(.viewModel, .legacyUI))
    func viewModelSubmitsWorldChanges() throws {
        let viewModel = CartographyMapViewModel()
        let file = CartographyMapFile(withManifest: .sampleFile)

//        await MainActor.run {
            viewModel.currentRoute = .editWorld
//        }

        viewModel.submitWorldChanges(to: file)
        #expect(viewModel.currentRoute == nil)
    }

    @Test(.timeLimit(.minutes(1)), .tags(.viewModel, .legacyUI), .enabled(if: Testchamber.platform(is: .iOS)))
    func viewModelRouteBindingsMobile() throws {
        let viewModel = CartographyMapViewModel()
//        await MainActor.run {
            viewModel.currentRoute = .editWorld
//        }

        #expect(viewModel.displayCurrentRouteAsInspector.wrappedValue == false)
        #expect(viewModel.displayCurrentRouteModally.wrappedValue == false)
    }

    @Test(.timeLimit(.minutes(1)), .tags(.viewModel, .legacyUI), .enabled(if: Testchamber.platform(is: .macOS)))
    func viewModelRouteBindingsDesktop() throws {
        let viewModel = CartographyMapViewModel()
//        await MainActor.run {
            viewModel.currentRoute = .editWorld
//        }

        #expect(viewModel.displayCurrentRouteAsInspector.wrappedValue == false)
        #expect(viewModel.displayCurrentRouteModally.wrappedValue == true)

        viewModel.displayCurrentRouteModally.wrappedValue = false
        #expect(viewModel.currentRoute == nil)
    }
}
