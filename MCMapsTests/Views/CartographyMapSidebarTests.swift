//
//  CartographyMapSidebarTests.swift
//  MCMaps
//
//  Created by Marquis Kurt on 26-02-2025.
//

import SwiftUI
import Testing
import ViewInspector

@testable import Alidade

@MainActor
struct CartographyMapSidebarTests {
    @Test func sidebarInit() throws {
        let file = Binding(wrappedValue: CartographyMapFile(map: .sampleFile))
        let viewModel = Binding(wrappedValue: CartographyMapViewModel())
        let sidebar = CartographyMapSidebar(viewModel: viewModel, file: file)

        #expect(sidebar.testHooks.searchState == .initial)
        #expect(sidebar.testHooks.world != nil)
        #if os(iOS)
            #expect(sidebar.testHooks.searchBarPlacement == .navigationBarDrawer(displayMode: .always))
        #else
            #expect(sidebar.testHooks.searchBarPlacement == .sidebar)
        #endif
    }

    @Test
    func sidebarSearchResults() async throws {
        let file = Binding(wrappedValue: CartographyMapFile(map: .sampleFile))
        let viewModel = Binding(wrappedValue: CartographyMapViewModel())
        let sidebar = CartographyMapSidebar(viewModel: viewModel, file: file)

        #expect(sidebar.testHooks.searchState == .initial)
        #expect(sidebar.testHooks.world != nil)

        viewModel.wrappedValue.searchQuery = "awn"

        await withKnownIssue("Main actor causes data race") {
            await sidebar.testHooks.triggerSearch()

            guard case let .found(searchResults) = sidebar.testHooks.searchState else {
                Issue.record("Search state is invalid! \(sidebar.testHooks.searchState)")
                return
            }
            
            #expect(!searchResults.isEmpty)
            #expect(sidebar.testHooks.world != nil)
        }
    }

    @Test func pushToRecentLocations() throws {
        let file = Binding(wrappedValue: CartographyMapFile(map: .sampleFile))
        let viewModel = Binding(wrappedValue: CartographyMapViewModel())
        let sidebar = CartographyMapSidebar(viewModel: viewModel, file: file)

        sidebar.pushToRecentLocations(.zero)
        #expect(file.wrappedValue.map.recentLocations?.count == 1)
        #expect(viewModel.wrappedValue.currentRoute == .recent(.zero))
    }

    @Test func pushToRecentLocationsPurgesRecent() throws {
        var filledFile = CartographyMapFile(map: .sampleFile)
        filledFile.map.recentLocations = Array(repeating: .zero, count: 15)
        let file = Binding(wrappedValue: filledFile)
        let viewModel = Binding(wrappedValue: CartographyMapViewModel())
        let sidebar = CartographyMapSidebar(viewModel: viewModel, file: file)

        sidebar.pushToRecentLocations(.init(x: 11, y: 11))
        #expect(file.wrappedValue.map.recentLocations?.count == 15)
        #expect(file.wrappedValue.map.recentLocations?.last == .init(x: 11, y: 11))
    }
}

// FIXME: Bad! Bad! Stop the JavaScript bullshit! Bad!

extension SearchFieldPlacement: @retroactive Equatable {
    public static func == (lhs: SearchFieldPlacement, rhs: SearchFieldPlacement) -> Bool {
        return String(describing: lhs) == String(describing: rhs)
    }
}
