//
//  CartographyMapViewModelTests.swift
//  MCMaps
//
//  Created by Marquis Kurt on 04-02-2025.
//

import CubiomesKit
import Foundation
import SwiftUI
import Testing

@testable import Alidade

struct CartographyMapViewModelTests {
    typealias SizeClass = UserInterfaceSizeClass
    typealias Coordinate = Point3D<Int32>

    @Test(.timeLimit(.minutes(1)), .tags(.viewModel))
    func viewModelInit() async throws {
        let viewModel = await CartographyMapViewModel()
        #expect(await viewModel.currentRoute == nil)
        #expect(await viewModel.displayCurrentRouteModally.wrappedValue == false)
        #expect(await viewModel.searchQuery.isEmpty)
        #expect(await viewModel.worldDimension == .overworld)
        #expect(await viewModel.worldRange.origin == Coordinate(x: 0, y: 15, z: 0))
        #expect(await viewModel.worldRange.size == MinecraftWorldRect.Size(length: 256, width: 256, height: 1))
    }

    @Test(.timeLimit(.minutes(1)), .tags(.viewModel))
    func viewModelPositionLabel() async throws {
        let viewModel = await CartographyMapViewModel()
        #expect(await viewModel.positionLabel == "X: 0, Z: 0")

        await MainActor.run {
            viewModel.worldRange.origin = .init(cgPoint: CGPoint(x: 1847, y: 1847))
        }

        #expect(await viewModel.positionLabel == "X: 1847, Z: 1847")
    }

    @Test(.timeLimit(.minutes(1)), .tags(.viewModel))
    func viewModelGoesToPosition() async throws {
        let viewModel = await CartographyMapViewModel()
        let file = CartographyMapFile(map: .sampleFile)
        #expect(await viewModel.worldRange.origin == .init(x: 0, y: 15, z: 0))

        await viewModel.go(to: .init(x: 1847, y: 1847), relativeTo: file)
        #expect(await viewModel.worldRange.origin == .init(x: 1847, y: 15, z: 1847))
    }

    @Test(.timeLimit(.minutes(1)), .tags(.viewModel))
    func viewModelSubmitsWorldChanges() async throws {
        let viewModel = await CartographyMapViewModel()
        let file = CartographyMapFile(map: .sampleFile)

        await MainActor.run {
            viewModel.currentRoute = .editWorld
        }

        await viewModel.submitWorldChanges(to: file)
        #expect(await viewModel.currentRoute == nil)
    }

    @Test(.timeLimit(.minutes(1)), .tags(.viewModel), .enabled(if: platform(is: .iOS)))
    func viewModelRouteBindingsMobile() async throws {
        let viewModel = await CartographyMapViewModel()
        await MainActor.run {
            viewModel.currentRoute = .editWorld
        }

        #expect(await viewModel.displayCurrentRouteAsInspector.wrappedValue == false)
        #expect(await viewModel.displayCurrentRouteModally.wrappedValue == false)
    }

    @Test(.timeLimit(.minutes(1)), .tags(.viewModel), .enabled(if: platform(is: .macOS)))
    func viewModelRouteBindingsDesktop() async throws {
        let viewModel = await CartographyMapViewModel()
        await MainActor.run {
            viewModel.currentRoute = .editWorld
        }

        #expect(await viewModel.displayCurrentRouteAsInspector.wrappedValue == false)
        #expect(await viewModel.displayCurrentRouteModally.wrappedValue == true)

        await viewModel.displayCurrentRouteModally.wrappedValue = false
        #expect(await viewModel.currentRoute == nil)
    }
}
