//
//  CartographySearchView.swift
//  MCMaps
//
//  Created by Marquis Kurt on 08-06-2025.
//

import AsyncAlgorithms
import CubiomesKit
import MCMap
import SwiftUI

/// A view that displays an interface for searching through content provided in a file.
///
/// The search view requires an initial and result view, as these will be served when a search has been performed, or
/// when the view is in its initial state. Queries are currently handled internally and requires no additional bindings
/// on the developer's part.
struct CartographySearchView<InitialView: View, ResultsView: View>: View {
    @FeatureFlagged(.redWindow) private var useRedWindowDesign

    /// A typealias pointing to the search query type.
    typealias SearchQuery = CartographySearchService.Query

    /// A typealias pointing to the search result type.
    typealias SearchResult = CartographySearchService.SearchResult

    /// A typealias pointing to the search token type.
    typealias SearchToken = CartographySearchService.SearchFilter

    /// An enumeration of the search states the view can undergo.
    enum SearchState: Equatable, Hashable {
        /// The initial search state.
        case initial

        /// The view is actively performing a search.
        case searching

        /// The search service returned a search result.
        case found(SearchResult)
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

    /// The file that the search service will perform operations on.
    var file: CartographyMapFile

    /// The player's current position on the map.
    var position: MinecraftPoint

    /// The player's current dimension.
    var dimension: MinecraftWorld.Dimension

    /// The view to display when in the initial state.
    var initial: () -> InitialView

    /// The view to display when the search service has returned results.
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

    /// Assign an action to when the search bar becomes the currently focused element.
    ///
    /// This is typically used in views to adjust the layout, such as with the ``CartographyMapSidebar``.
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

            // NOTE(alicerunsonfedora): Recent iOS betas changed the search bar placement so it's always in the toolbar
            // on iPad and Mac. Which is great (and what we want), but it seems the search bar is a little short, so
            // having "Pinned Places, Biomes, Structures, and More" as a placeholder prompt doesn't read well because
            // it gets prematurely truncated.
            //
            // For now, set this to 'Search' and watch future betas to see if the search bar size changes at all.
            prompt: useRedWindowDesign ? "Search" : "Go To..."
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
        let fileTags = file.tags
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
