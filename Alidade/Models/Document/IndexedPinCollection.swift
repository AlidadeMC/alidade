//
//  PinCollection.swift
//  MCMaps
//
//  Created by Marquis Kurt on 18-06-2025.
//

import Foundation
import MCMap

/// A collection of pins, organized by index.
///
/// This wrapper collection is used to better handle interactions with SwiftUI where the index of the pin is required,
/// such as for modifying pins. Prefer using this collection type over `Array(file.manifest.pins.enumerated())`:
///
/// ```swift
/// import SwiftUI
///
/// struct MyView: View {
///     @Binding var file: CartographyMapFile
///
///     var body: some View {
///         ForEach(IndexedPinCollection(file.manifest.pins)) { pin in
///             ...
///         }
///     }
/// }
/// ```
struct IndexedPinCollection {
    fileprivate typealias InternalContainer = [CartographyMapPin]
    /// A structure representing an element in the collection.
    struct Element: Identifiable, Equatable, Hashable {
        /// A unique identifier for the element.
        var id: Int { index }

        /// The index where the pin can be found in the source list.
        var index: Int

        /// The contents of the pin.
        var content: CartographyMapPin
    }

    private var elements: [CartographyMapPin]

    /// Create a collection from an existing array of pins.
    init(_ elements: [CartographyMapPin]) {
        self.elements = elements
    }
}

extension IndexedPinCollection: Codable {
    func encode(to encoder: any Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(elements)
    }

    init(from decoder: any Decoder) throws {
        let container = try decoder.singleValueContainer()
        self.elements = try container.decode(InternalContainer.self)
    }
}

extension IndexedPinCollection: Equatable {}

extension IndexedPinCollection: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(elements)
    }
}

extension IndexedPinCollection: ExpressibleByArrayLiteral {
    typealias ArrayLiteralElement = CartographyMapPin

    init(arrayLiteral elements: CartographyMapPin...) {
        self.init(elements)
    }
}

extension IndexedPinCollection: Collection {
    typealias Index = [CartographyMapPin].Index

    var startIndex: Array<CartographyMapPin>.Index {
        elements.startIndex
    }

    var endIndex: Array<CartographyMapPin>.Index {
        elements.endIndex
    }

    subscript(position: Array<CartographyMapPin>.Index) -> Element {
        return Element(index: Int(position), content: elements[position])
    }

    func index(after index: Array<CartographyMapPin>.Index) -> Array<CartographyMapPin>.Index {
        elements.index(after: index)
    }
}

extension IndexedPinCollection: RandomAccessCollection {}
