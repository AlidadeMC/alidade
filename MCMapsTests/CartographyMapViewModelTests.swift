//
//  CartographyMapViewModelTests.swift
//  MCMaps
//
//  Created by Marquis Kurt on 04-02-2025.
//

@testable import Alidade
import CubiomesKit
import Foundation
import SwiftUI
import Testing

struct CartographyMapViewModelTests {
    typealias SizeClass = UserInterfaceSizeClass
    typealias Coordinate = Point3D<Int32>

    @Test func viewModelInit() async throws {
        let viewModel = await CartographyMapViewModel()
        #expect(await viewModel.displayChangeSeedForm == false)
        #expect(await viewModel.displayNewPinForm == false)
        #expect(await viewModel.searchQuery.isEmpty)
        #expect(await viewModel.state == .loading)
        #expect(await viewModel.worldDimension == .overworld)
        #expect(await viewModel.worldRange.position == Coordinate(x: 0, y: 15, z: 0))
        #expect(await viewModel.worldRange.scale == Coordinate(x: 256, y: 1, z: 256))
        #expect(await viewModel.locationToPin == .zero)
        
        #if os(iOS)
        #expect(await viewModel.displaySidebarSheet == false)
        #endif
    }

    @Test func viewModelPositionLabel() async throws {
        let viewModel = await CartographyMapViewModel()
        #expect(await viewModel.positionLabel == "X: 0, Z: 0")
    
        await MainActor.run {
            viewModel.worldRange.position = .init(cgPoint: CGPoint(x: 1847, y: 1847))
        }
        
        #expect(await viewModel.positionLabel == "X: 1847, Z: 1847")
    }

    @Test(arguments: ["", "letz", "Letz", "hotel", "Hotel"])
    func viewModelFiltersPins(query: String) async throws {
        let letztesJar = CartographyMapPin(position: .init(x: 1847, y: 1847), name: "Hotel Letztes Jahr")
        let pins = [
            CartographyMapPin(position: .zero, name: "Some Location"),
            letztesJar
        ]
        let viewModel = await CartographyMapViewModel()
        await MainActor.run {
            viewModel.searchQuery = query
        }

        if query.isEmpty {
            #expect(await viewModel.filterPinsByQuery(pins: pins) == pins)
        } else {
            let filtered = await viewModel.filterPinsByQuery(pins: pins)
            #expect(filtered.count == 1)
            #expect(filtered.first == letztesJar)
        }
    }

    @Test(arguments: [("1.2", 123, true), ("fail", 123, false)])
    func viewModelRefreshMap(version: String, seed: Int64, shouldSucceed: Bool) async throws {
        let viewModel = await CartographyMapViewModel()
        #expect(await viewModel.state == .loading)

        await viewModel.refreshMap(seed, for: version)

        if shouldSucceed {
            guard case .success = await viewModel.state else {
                Issue.record("An error occurred.")
                return
            }
        } else {
            #expect(await viewModel.state == .unavailable)
        }
    }

    @Test func viewModelGoesToPosition() async throws {
        let viewModel = await CartographyMapViewModel()
        #expect(await viewModel.state == .loading)
        #expect(await viewModel.worldRange.position == .init(x: 0, y: 15, z: 0))

        await viewModel.goTo(position: .init(x: 1847, y: 1847), seed: 123, mcVersion: "1.8")
        #expect(await viewModel.worldRange.position == .init(x: 1847, y: 15, z: 1847))
        guard case .success = await viewModel.state else {
            Issue.record("An error occurred.")
            return
        }
    }

    @Test func viewModelGoesToRegexPosition() async throws {
        let positionMatch = "1847, 1847".matches(of: /(-?\d+), (-?\d+)/)
        guard let regexPosition = positionMatch.first else {
            Issue.record("Regex didn't match.")
            return
        }
        let viewModel = await CartographyMapViewModel()
        #expect(await viewModel.worldRange.position == .init(x: 0, y: 15, z: 0))

        await viewModel.goToRegexPosition(regexPosition.output, seed: 123, mcVersion: "1.8") { point in
            #expect(point == .init(x: 1847, y: 1847))
        }
        guard case .success = await viewModel.state else {
            Issue.record("An error occurred.")
            return
        }
        #expect(await viewModel.worldRange.position == .init(x: 1847, y: 15, z: 1847))
    }

    @Test func viewModelPresentsWorldChangesForm() async throws {
        let viewModel = await CartographyMapViewModel()
        #expect(await viewModel.displayChangeSeedForm == false)
        #if os(iOS)
        // This only gets enabled when a view changes this based on horizontal size class.
        #expect(await viewModel.displaySidebarSheet == false)
        #endif
    
        await viewModel.presentWorldChangesForm()
        #expect(await viewModel.displayChangeSeedForm == true)
        #if os(iOS)
        #expect(await viewModel.displaySidebarSheet == false)
        #endif
    }

    @Test func viewModelPresentsNewPinForm() async throws {
        let viewModel = await CartographyMapViewModel()
        #expect(await viewModel.displayNewPinForm == false)
        #if os(iOS)
        // This only gets enabled when a view changes this based on horizontal size class.
        #expect(await viewModel.displaySidebarSheet == false)
        #endif
    
        await viewModel.presentNewPinForm(for: .zero)
        #expect(await viewModel.displayNewPinForm == true)
        #if os(iOS)
        #expect(await viewModel.displaySidebarSheet == false)
        #endif
    }

    @Test(arguments: [(SizeClass.compact, true), (SizeClass.regular, false)])
    func viewModelCancelsWorldChangesPresentation(sizeClass: SizeClass, shouldDisplay: Bool) async throws {
        let viewModel = await CartographyMapViewModel()
        #expect(await viewModel.displayChangeSeedForm == false)
        #if os(iOS)
        // This only gets enabled when a view changes this based on horizontal size class.
        #expect(await viewModel.displaySidebarSheet == false)
        #endif
    
        await viewModel.presentWorldChangesForm()
        #expect(await viewModel.displayChangeSeedForm == true)
        #if os(iOS)
        #expect(await viewModel.displaySidebarSheet == false)
        #endif

        await viewModel.cancelWorldChanges(sizeClass)
        #expect(await viewModel.displayChangeSeedForm == false)
        #expect(await viewModel.displaySidebarSheet == shouldDisplay)
    }

    @Test(arguments: [(SizeClass.compact, true), (SizeClass.regular, false)])
    func viewModelSubmitssWorldChangesPresentation(sizeClass: SizeClass, shouldDisplay: Bool) async throws {
        let viewModel = await CartographyMapViewModel()
        #expect(await viewModel.displayChangeSeedForm == false)
        #if os(iOS)
        // This only gets enabled when a view changes this based on horizontal size class.
        #expect(await viewModel.displaySidebarSheet == false)
        #endif
    
        await viewModel.presentWorldChangesForm()
        #expect(await viewModel.displayChangeSeedForm == true)
        #if os(iOS)
        #expect(await viewModel.displaySidebarSheet == false)
        #endif

        await viewModel.submitWorldChanges(seed: 1234, mcVersion: "1.9", sizeClass)
        #expect(await viewModel.displayChangeSeedForm == false)
        #expect(await viewModel.displaySidebarSheet == shouldDisplay)
        guard case .success = await viewModel.state else {
            Issue.record("An error occurred.")
            return
        }
    }
}
