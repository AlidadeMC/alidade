//
//  CartographyMapSidebar.swift
//  MCMaps
//
//  Created by Marquis Kurt on 01-02-2025.
//

import CubiomesKit
import SwiftUI
import TipKit

/// The sidebar content for the main app.
///
/// This will appear as the sheet content in the app's adaptable sidebar sheet, and as the sidebar in the
/// ``CartographyMapSplitView``.
struct CartographyMapSidebar: View {
    enum SearchingState: Equatable {
        case initial
        case searching
        case found(CartographySearchService.SearchResult)
    }

    private enum LocalTips {
        static var onboarding = LibraryOnboardingTip()
        static var emptyLibrary = PinActionOnboardingTip()
    }

    @Environment(\.isSearching) private var isSearching
    @Environment(\.dismissSearch) private var dismissSearch

    /// The view model the sidebar will interact with.
    @Binding var viewModel: CartographyMapViewModel

    /// The file that the sidebar will read from and write to.
    ///
    /// Notably, the sidebar content will read from recent locations and the player-created pins.
    @Binding var file: CartographyMapFile

    @State private var searchingState = SearchingState.initial

    private var searchBarPlacement: SearchFieldPlacement {
        #if os(macOS)
            return .sidebar
        #else
            return .navigationBarDrawer(displayMode: .always)
        #endif
    }

    var body: some View {
        Group {
            #if os(macOS)
                List(selection: $viewModel.currentRoute) {
                    listContents
                }
            #else
                List {
                    listContents
                }
            #endif
        }

        .frame(minWidth: 175, idealWidth: 200)
        .searchable(text: $viewModel.searchQuery, placement: searchBarPlacement, prompt: "Go To...")
        .animation(.default, value: searchingState)
        .onAppear {
            if file.map.pins.isEmpty {
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
        .onSubmit(of: .search) {
            Task {
                await search()
            }
        }
        .onChange(of: viewModel.searchQuery) { _, newValue in
            if newValue.isEmpty {
                searchingState = .initial
            }
        }
        .onChange(of: file.map.pins) { _, newValue in
            if !newValue.isEmpty {
                LocalTips.emptyLibrary.invalidate(reason: .actionPerformed)
            }
        }
    }

    private var listContents: some View {
        Group {
            Group {
                switch searchingState {
                case .initial:
                    defaultView
                case .searching:
                    HStack {
                        Spacer()
                        Label {
                            Text("Searching...")
                                .font(.subheadline)
                                .bold()
                        } icon: {
                            Image(systemName: "magnifyingglass.circle")
                                .symbolEffect(.breathe)
                                .imageScale(.large)
                        }
                        Spacer()
                    }
                    .padding(.vertical)
                    #if os(iOS)
                        .listRowBackground(Color.clear)
                        .listRowInsets(.zero)
                        .listRowSeparator(.hidden)
                    #endif
                case .found(let results):
                    if let jumpToCoordinate = results.coordinates.first {
                        CartographyNamedLocationView(
                            name: "Jump Here",
                            location: jumpToCoordinate,
                            systemImage: "figure.run",
                            color: .accent
                        )
                        .onTapGesture {
                            withAnimation {
                                viewModel.go(to: jumpToCoordinate, relativeTo: file)
                                pushToRecentLocations(jumpToCoordinate)
                                viewModel.searchQuery = ""
                                if viewModel.currentRoute != nil {
                                    viewModel.currentRoute = nil
                                }
                            }
                        }
                    }

                    if !results.pins.isEmpty {
                        PinnedLibrarySection(pins: results.pins, viewModel: $viewModel, file: $file)
                    }

                    GroupedPinsSection(
                        pins: results.structures,
                        viewModel: $viewModel,
                        file: $file
                    ) { jumpedToPin in
                        withAnimation {
                            pushToRecentLocations(jumpedToPin.position)
                            viewModel.searchQuery = ""
                            searchingState = .initial
                        }
                    }

                    GroupedPinsSection(
                        name: "Biomes", pins: results.biomes, viewModel: $viewModel, file: $file
                    ) { jumpedToPin in
                        withAnimation {
                            pushToRecentLocations(jumpedToPin.position)
                            viewModel.searchQuery = ""
                            searchingState = .initial
                        }
                    }
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
            if !file.map.pins.isEmpty {
                PinnedLibrarySection(pins: file.map.pins, viewModel: $viewModel, file: $file)
            }
            if file.map.recentLocations?.isEmpty == false {
                RecentLocationsListSection(viewModel: $viewModel, file: $file) { (position: CGPoint) in
                    viewModel.go(to: position, relativeTo: file)
                }
            }
        }
    }

    private var world: MinecraftWorld? {
        try? MinecraftWorld(version: file.map.mcVersion, seed: file.map.seed)
    }

    func pushToRecentLocations(_ position: CGPoint) {
        if file.map.recentLocations == nil {
            file.map.recentLocations = [position]
            return
        }
        file.map.recentLocations?.append(position)
        if (file.map.recentLocations?.count ?? 0) > 15 {
            file.map.recentLocations?.remove(at: 0)
        }
        viewModel.currentRoute = .recent(position)
    }

    private func search() async {
        guard let world else {
            searchingState = .initial
            return
        }
        LocalTips.onboarding.invalidate(reason: .actionPerformed)
        searchingState = .searching
        let service = CartographySearchService()
        let results =
            await service
            .search(
                viewModel.searchQuery,
                world: world,
                file: file,
                currentPosition: viewModel.worldRange.position,
                dimension: viewModel.worldDimension
            )
        searchingState = .found(results)
    }
}

#if DEBUG
    extension CartographyMapSidebar {
        var testHooks: TestHooks { TestHooks(target: self) }

        struct TestHooks {
            private let target: CartographyMapSidebar

            fileprivate init(target: CartographyMapSidebar) {
                self.target = target
            }

            var world: MinecraftWorld? {
                target.world
            }

            var searchState: SearchingState {
                target.searchingState
            }

            var searchBarPlacement: SearchFieldPlacement {
                target.searchBarPlacement
            }

            func triggerSearch() async {
                await target.search()
            }
        }
    }
#endif
