//
//  PinCollection.swift
//  MCMaps
//
//  Created by Marquis Kurt on 18-06-2025.
//

import Bedrock
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
typealias IndexedPinCollection = IndexedCollection<CartographyMapPin>
