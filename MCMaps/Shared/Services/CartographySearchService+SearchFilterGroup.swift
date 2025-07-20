//
//  CartographySearchService+SearchFilterGroup.swift
//  MCMaps
//
//  Created by Marquis Kurt on 01-06-2025.
//

import MCMap

extension CartographySearchService {
    /// An enumeration representing the various filter types for a search.
    enum SearchFilter: Sendable, Hashable, Equatable, Identifiable {
        var id: Self { self }

        /// Filter by a specific tag.
        case tag(String)
    }

    /// A collection of search filters.
    struct SearchFilterGroup {
        fileprivate var filters: Set<SearchFilter>

        /// Initialize a search filter group with a set of filters.
        /// - Parameter filters: The filters to include in the filter group.
        init(filters: Set<SearchFilter> = []) {
            self.filters = filters
        }
    }
}

extension CartographySearchService.SearchFilterGroup {
    func matchTags(for pin: MCMapManifestPin) -> Set<CartographySearchService.SearchFilter> {
        var matches = Set<CartographySearchService.SearchFilter>()
        guard let pinTags = pin.tags else {
            return []
        }

        for tag in pinTags {
            let filter: CartographySearchService.SearchFilter = .tag(tag)
            if filters.contains(filter) {
                matches.insert(filter)
            }
        }

        return matches
    }
}

extension CartographySearchService.SearchFilterGroup: Collection {
    typealias Element = CartographySearchService.SearchFilter
    typealias Index = Set<CartographySearchService.SearchFilter>.Index

    var startIndex: Index { filters.startIndex }
    var endIndex: Index { filters.endIndex }

    func index(after index: Set<CartographySearchService.SearchFilter>.Index) -> Index {
        filters.index(after: index)
    }

    subscript(position: Set<CartographySearchService.SearchFilter>.Index) -> CartographySearchService.SearchFilter {
        return filters[position]
    }
}
