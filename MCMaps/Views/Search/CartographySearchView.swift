//
//  CartographySearchView.swift
//  MCMaps
//
//  Created by Marquis Kurt on 08-06-2025.
//

import AsyncAlgorithms
import CubiomesKit
import SwiftUI

struct CartographySearchView<InitialView: View, ResultsView: View>: View {
    typealias SearchQuery = CartographySearchService.Query
    typealias SearchResult = CartographySearchService.SearchResult
    typealias SearchToken = CartographySearchService.SearchFilter

    enum SearchState: Equatable, Hashable {
        case initial
        case searching
        case found(CartographySearchService.SearchResult)
    }

    private enum Constants {
        static var searchBarPlacement: SearchFieldPlacement {
            #if os(macOS)
                return .sidebar
            #else
                return .navigationBarDrawer(displayMode: .always)
            #endif
        }
    }

    @State var searchState = SearchState.initial
    @State var query: SearchQuery = ""
    @State var tokens = [SearchToken]()

    var file: CartographyMapFile
    var position: MinecraftPoint
    var dimension: MinecraftWorld.Dimension

    var initial: () -> InitialView
    var results: (SearchResult) -> ResultsView

    #if DEBUG
        var prefill: (() -> SearchQuery)?
    #endif

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
        .searchable(text: $query, tokens: $tokens, prompt: "Go To...") { token in
            switch token {
            case let .tag(tagName):
                Text(tagName)
            }
        }
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
        .onAppear {
            #if DEBUG
                if let prefilledQuery = prefill?() {
                    query = prefilledQuery
                }
            #endif
        }
        .onChange(of: query) { _, newValue in
            if newValue.isEmpty, tokens.isEmpty {
                searchState = .initial
            }
        }
        .onChange(of: tokens) { _, newValue in
            if newValue.isEmpty, query.isEmpty {
                searchState = .initial
            }
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
        let results = await service.search(for: query, in: context, filters: filterGroup)
        searchState = .found(results)
    }

    private func getSuggestions() -> [SearchToken] {
        let fileTags = file.manifest.getAllAvailableTags()
        let matchingTags = fileTags.filter { tag in query.lowercased().contains(tag.lowercased()) }
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
                target.query
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
