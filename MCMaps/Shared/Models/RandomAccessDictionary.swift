//
//  RandomAccessDictionary.swift
//  MCMaps
//
//  Created by Marquis Kurt on 16-07-2025.
//

import Foundation

/// A dictionary collection designed to work with `ForEach` types or other APIs that require a random access
/// collection.
///
/// In most cases, you likely don't need to use this type to work with a dictionary. However, this type can be used
/// with APIs that need a random access collection, such as `ForEach`:
///
/// ```swift
/// import SwiftUI
///
/// struct MyView: View {
///     var myDict: [String: Int] = ["Apples": 10, "Bananas": 15]
///
///     var body: some View {
///         List {
///             ForEach(RandomAccessDictionary(myDict)) { element in
///                 Label(
///                     "\(element.key): $\(element.value)",
///                     systemImage: "tag")
///             }
///         }
///     }
/// }
/// ```
struct RandomAccessDictionary<Key: Hashable, Value> {
    private var dictionary: [Key: Value]

    /// Create a random access dictionary from an existing dictionary.
    /// - Parameter dictionary: The dictionary to create a random access dictionary for.
    init(_ dictionary: [Key: Value]) {
        self.dictionary = dictionary
    }
}

extension RandomAccessDictionary: Collection {
    struct Element: Identifiable {
        /// The ID for the element.
        var id: Key { self.key }

        /// The key of the element in the dictionary.
        var key: Key

        /// The value of the element in the dictionary, accessed via ``key``.
        var value: Value
    }

    typealias Index = Dictionary<Key, Value>.Index

    var startIndex: Index { dictionary.startIndex }
    var endIndex: Index { dictionary.endIndex }

    func index(after index: Index) -> Index {
        dictionary.index(after: index)
    }

    subscript(position: Dictionary<Key, Value>.Index) -> Element {
        let (key, value) = dictionary[position]
        return Element(key: key, value: value)
    }
}

extension RandomAccessDictionary.Element: Equatable where Key: Equatable, Value: Equatable {}

extension RandomAccessDictionary: RandomAccessCollection {
    // NOTE: This is more or less a dummy function, because dictionaries are unordered!
    func index(before index: Index) -> Index {
        let offset = self.distance(from: startIndex, to: index)
        return dictionary.index(
            after: dictionary.index(dictionary.startIndex, offsetBy: offset - 1)
        )
    }
}

extension RandomAccessDictionary: ExpressibleByDictionaryLiteral {
    init(dictionaryLiteral elements: (Key, Value)...) {
        self.dictionary = [:]
        for element in elements {
            self.dictionary[element.0] = element.1
        }
    }
}
