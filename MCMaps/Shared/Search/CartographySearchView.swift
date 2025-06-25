//
//  CartographySearchView.swift
//  MCMaps
//
//  Created by Marquis Kurt on 08-06-2025.
//

import AsyncAlgorithms
import CubiomesKit
import MCMapFormat
import SwiftUI

struct CartographySearchView<InitialView: View, ResultsView: View>: View {
    @FeatureFlagged(.redWindow) private var useRedWindowDesign

    typealias SearchQuery = CartographySearchService.Query
    typealias SearchResult = CartographySearchService.SearchResult
    typealias SearchToken = CartographySearchService.SearchFilter

    enum SearchState: Equatable, Hashable {
        case initial
        case searching
        case found(CartographySearchService.SearchResult)
    }

    private enum Constants {
        static var searchFieldPlacement: SearchFieldPlacement {
            #if os(macOS) || RED_WINDOW
                return .automatic
            #else
                return .navigationBarDrawer(displayMode: .always)
            #endif
        }
    }

    @FocusState private var searchFocused: Bool

    @State private var searchState = SearchState.initial
    @State private var rawQuery: SearchQuery = ""
    @State private var tokens = [SearchToken]()

    var file: CartographyMapFile
    var position: MinecraftPoint
    var dimension: MinecraftWorld.Dimension

    var initial: () -> InitialView
    var results: (SearchResult) -> ResultsView

    private var searchGainedFocus: (() -> Void)?

    init(
        file: CartographyMapFile,
        position: MinecraftPoint,
        dimension: MinecraftWorld.Dimension,
        initial: @escaping () -> InitialView,
        results: @escaping (SearchResult) -> ResultsView
    ) {
        self.file = file
        self.position = position
        self.dimension = dimension
        self.initial = initial
        self.results = results
    }

    fileprivate init(
        file: CartographyMapFile,
        position: MinecraftPoint,
        dimension: MinecraftWorld.Dimension,
        initial: @escaping () -> InitialView,
        results: @escaping (SearchResult) -> ResultsView,
        searchGainedFocus: (() -> Void)? = nil
    ) {
        self.file = file
        self.position = position
        self.dimension = dimension
        self.initial = initial
        self.results = results
        self.searchGainedFocus = searchGainedFocus
    }

    func searchBecomesFocused(_ callback: @escaping () -> Void) -> Self {
        CartographySearchView(
            file: file,
            position: position,
            dimension: dimension,
            initial: initial,
            results: results,
            searchGainedFocus: callback
        )
    }

    var body: some View {
        Group {
            switch searchState {
            case .initial:
                initial()
            case .searching:
                CartographySearchLabel()
            case .found(let searchResult):
                results(searchResult)
            }
        }
        .searchable(
            text: $rawQuery,
            tokens: $tokens,
            placement: Constants.searchFieldPlacement,
            prompt: useRedWindowDesign ? "Pinned Places, Biomes, Structures, and More" : "Go To..."
        ) { token in
            switch token {
            case let .tag(tagName):
                Text(tagName)
            }
        }
        .searchFocused($searchFocused)
        .searchSuggestions {
            ForEach(getSuggestions()) { searchToken in
                switch searchToken {
                case let .tag(tagName):
                    Label(tagName, systemImage: "tag")
                        .searchCompletion(searchToken)
                }
            }
        }
        .animation(.interactiveSpring, value: searchState)
        .onChange(of: rawQuery) { _, newValue in
            if newValue.isEmpty, tokens.isEmpty {
                searchState = .initial
            }
        }
        .onChange(of: tokens) { _, newValue in
            if newValue.isEmpty, rawQuery.isEmpty {
                searchState = .initial
            }
        }
        .onChange(of: searchFocused) { _, newValue in
            if newValue { searchGainedFocus?() }
        }
        .onSubmit(of: .search) {
            Task { await performSearch() }
        }
    }

    private func performSearch() async {
        guard let world = try? MinecraftWorld(worldSettings: file.manifest.worldSettings) else {
            searchState = .initial
            return
        }
        searchState = .searching

        let service = CartographySearchService()
        let context = CartographySearchService.SearchContext(
            world: world,
            file: file,
            position: position,
            dimension: dimension)
        let filterGroup = CartographySearchService.SearchFilterGroup(filters: Set(tokens))
        let results = await service.search(for: rawQuery, in: context, filters: filterGroup)
        searchState = .found(results)
    }

    private func getSuggestions() -> [SearchToken] {
        let fileTags = file.manifest.getAllAvailableTags()
        let matchingTags = fileTags.filter { tag in rawQuery.lowercased().contains(tag.lowercased()) }
        return matchingTags.map { SearchToken.tag($0) }
    }
}

#if DEBUG
    extension CartographySearchView {
        var testHooks: TestHooks { TestHooks(target: self) }

        @MainActor
        struct TestHooks {
            private let target: CartographySearchView

            fileprivate init(target: CartographySearchView) {
                self.target = target
            }

            var searchState: CartographySearchView.SearchState {
                target.searchState
            }

            var searchQuery: CartographySearchView.SearchQuery {
                target.rawQuery
            }

            func triggerSearch() async {
                await target.performSearch()
            }

            func getSuggestions() -> [SearchToken] {
                target.getSuggestions()
            }
        }
    }
#endif
