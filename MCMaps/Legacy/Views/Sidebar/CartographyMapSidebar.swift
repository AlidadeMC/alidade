//
//  CartographyMapSidebar.swift
//  MCMaps
//
//  Created by Marquis Kurt on 01-02-2025.
//

import AlidadeUI
import CubiomesKit
import MCMap
import SwiftUI
import TipKit

/// The sidebar content for the main app.
///
/// This will appear as the sheet content in the app's adaptable sidebar sheet, and as the sidebar in the
/// ``CartographyMapSplitView``.
@available(macOS, introduced: 15.0, deprecated: 26.0)
@available(iOS, introduced: 18.0, deprecated: 26.0)
struct CartographyMapSidebar: View {
    private enum LocalTips {
        static let onboarding = LibraryOnboardingTip()
        static let emptyLibrary = PinActionOnboardingTip()
    }

    @Environment(\.isSearching) private var isSearching
    @Environment(\.dismissSearch) private var dismissSearch

    /// The view model the sidebar will interact with.
    @Binding var viewModel: CartographyMapViewModel

    /// The file that the sidebar will read from and write to.
    ///
    /// Notably, the sidebar content will read from recent locations and the player-created pins.
    @Binding var file: CartographyMapFile

    var body: some View {
        CartographySearchView(file: file, position: viewModel.worldRange.origin, dimension: viewModel.worldDimension) {
            #if os(macOS)
                List(selection: $viewModel.currentRoute) {
                    defaultView
                }
            #else
                List {
                    defaultView
                }
            #endif
        } results: { searchResults in
            #if os(macOS)
                List(selection: $viewModel.currentRoute) {
                    view(forSearchResults: searchResults)
                }
            #else
                List {
                    view(forSearchResults: searchResults)
                }
            #endif
        }
        .searchBecomesFocused {
            if viewModel.presentationDetent == .small {
                withAnimation {
                    viewModel.presentationDetent = .medium
                }
            }
        }
        .frame(minWidth: 175, idealWidth: 200)
        .onAppear {
            if file.pins.isEmpty {
                Task {
                    await PinActionOnboardingTip.libraryEmpty.donate()
                }
            }
        }
        .onChange(of: viewModel.currentRoute) { _, newValue in
            switch newValue {
            case let .pin(_, pin):
                viewModel.go(to: pin.position, relativeTo: file)
            case let .recent(location):
                viewModel.go(to: location, relativeTo: file)
            default:
                break
            }
        }

        .onChange(of: file.pins) { _, newValue in
            if !newValue.isEmpty {
                LocalTips.emptyLibrary.invalidate(reason: .actionPerformed)
            }
        }
    }

    private func view(forSearchResults results: CartographySearchService_v2.SearchResult) -> some View {
        Group {
            if !results.pins.isEmpty {
                PinnedLibrarySection(pins: results.pins, viewModel: $viewModel, file: $file)
            }

            if !results.integratedData.isEmpty {
                GroupedPinsSection(
                    name: "From Integrations",
                    pins: results.integratedData,
                    viewModel: $viewModel,
                    file: $file
                )
            }

            GroupedPinsSection(
                pins: results.structures,
                viewModel: $viewModel,
                file: $file
            ) { jumpedToPin in
                withAnimation {
                    pushToRecentLocations(jumpedToPin.position)
                }
            }

            GroupedPinsSection(
                name: "Biomes", pins: results.biomes, viewModel: $viewModel, file: $file
            ) { jumpedToPin in
                withAnimation {
                    pushToRecentLocations(jumpedToPin.position)
                }
            }
        }
    }

    private var defaultView: some View {
        Group {
            TipView(LocalTips.onboarding)
                .tipViewStyle(.miniTip)
                .listRowSeparator(.hidden)
                .listRowBackground(Color.clear)
            TipView(LocalTips.emptyLibrary)
                .tipViewStyle(.miniTip)
                .listRowSeparator(.hidden)
                .listRowBackground(Color.clear)
            if file.manifest.recentLocations?.isEmpty == false {
                RecentLocationsListSection(viewModel: $viewModel, file: $file) { (position: CGPoint) in
                    viewModel.go(to: position, relativeTo: file)
                }
            }
            if !file.pins.isEmpty {
                PinnedLibrarySection(pins: file.pins, viewModel: $viewModel, file: $file)
            }
        }
    }

    func pushToRecentLocations(_ position: CGPoint) {
        if file.manifest.recentLocations == nil {
            file.manifest.recentLocations = [position]
            viewModel.currentRoute = .recent(position)
            return
        }
        file.manifest.recentLocations?.append(position)
        if (file.manifest.recentLocations?.count ?? 0) > 5 {
            file.manifest.recentLocations?.remove(at: 0)
        }
        viewModel.currentRoute = .recent(position)
    }
}

#if DEBUG
    extension CartographyMapSidebar {
        var testHooks: TestHooks { TestHooks(target: self) }

        @MainActor
        struct TestHooks {
            private let target: CartographyMapSidebar

            fileprivate init(target: CartographyMapSidebar) {
                self.target = target
            }
        }
    }
#endif
