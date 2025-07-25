//
//  CartographyPinViewModel.swift
//  MCMaps
//
//  Created by Marquis Kurt on 18-02-2025.
//

import MCMap
import SwiftUI

/// A view model used for manipulating a pin in a file directly.
///
/// Typically, this view model is used to manipulate pins in a file where the main content of a view is the pin itself,
/// such as an inspector or popover:
///
/// ```swift
/// import SwiftUI
///
/// struct MyPinEditor: View {
///     var viewModel: CartographyPinViewModel
///
///     var body: some View {
///         TextField("Name", text: viewModel.$pin.name)
///     }
/// }
/// ```
///
/// > Important: This view model should **not** be used to add or remove pins. Rather, this view model should be used
/// > to update pins in-place, assuming its index in the ``MCMapManifest/pins`` list is stable.
@available(macOS, introduced: 15.0, deprecated: 26.0)
@available(iOS, introduced: 18.0, deprecated: 26.0)
class CartographyPinViewModel {
    private var file: Binding<CartographyMapFile>
    private var index: Int

    /// The pin that will be edited through this view model.
    ///
    /// Changes to this property will automatically propagate to the file.
    var pin: Binding<CartographyMapPin>

    /// A binding to the pin's about description.
    ///
    /// This binding is intended to be used with text fields and editors to directly manipulate the about
    /// description's text. It is a mirror of the ``MCMapManifestPin/aboutDescription`` property, which will
    /// automatically generate an empty string if the property wasn't defined before.
    var pinAboutDescription: Binding<String>

    /// A binding to the pin's tags.
    ///
    /// This binding is intended to be used with chip text fields to manipulate the tags available to this pin. It
    /// mirrors the ``MCMapManifestPin/tags`` property, providing an empty set if it wasn't defined before.
    var pinTags: Binding<Set<String>>

    /// A binding to the pin's icon.
    var pinIcon: Binding<CartographyIcon>

    /// A label that can be used to describe the pin's current position.
    var pinLocationLabel: String {
        let location = pin.wrappedValue.position
        return "(\(Int(location.x)), \(Int(location.y)))"
    }

    /// A label displaying an overworld location as a location in the Nether.
    ///
    /// Nether coordinates are scaled by a scale of 1 nether block: 8 overworld blocks. This property is used to
    /// display this coordinate for players that might want to try reaching a specified location using Nether portals.
    var netherTranslatedCoordinate: String {
        let position = pin.wrappedValue.position
        var nether = CGPoint(x: position.x / 8, y: position.y / 8)
        nether.x = nether.x.rounded(.toNearestOrAwayFromZero)
        nether.y = nether.y.rounded(.toNearestOrAwayFromZero)
        return "(\(Int(nether.x)), \(Int(nether.y)))"
    }

    /// Whether the current file manifest supports pin tagging.
    var fileSupportsPinTags: Bool {
        (file.wrappedValue.manifest.manifestVersion ?? 1) > 1
    }

    /// Creates a view model from a file and given index.
    /// - Parameter file: The file that will be modified.
    /// - Parameter index: The location where the pin is found.
    init(file: Binding<CartographyMapFile>, index: Int) {
        self.file = file
        self.index = index
        self.pin = Binding {
            return file.wrappedValue.pins[index]
        } set: { newPin in
            file.wrappedValue.pins[index] = newPin
        }

        self.pinAboutDescription = file.pins[index].description

        self.pinTags = Binding {
            guard file.wrappedValue.supportedFeatures.contains(.pinTagging) else {
                return []
            }
            return file.wrappedValue.pins[index].tags ?? []
        } set: { newValue in
            guard file.wrappedValue.supportedFeatures.contains(.pinTagging) else {
                return
            }
            file.wrappedValue.pins[index].tags = newValue
        }

        self.pinIcon = Binding {
            guard file.wrappedValue.supportedFeatures.contains(.pinIcons) else {
                return .default
            }
            return file.wrappedValue.pins[index].icon ?? .default
        } set: { newValue in
            guard file.wrappedValue.supportedFeatures.contains(.pinIcons) else { return }
            file.wrappedValue.pins[index].icon = newValue
        }
    }

    /// Retrieves data blobs for the images associated with this pin.
    ///
    /// Images consist of player-uploaded screenshots that can be displayed alongside pins.
    func images() -> [Data] {
        let pin = file.wrappedValue.pins[index]
        guard let images = pin.images else { return [] }
        return images.compactMap { name in
            file.wrappedValue.images[name]
        }
    }

    /// Uploads a player-selected image to the file.
    ///
    /// The image will be given a UUID string, and it will be saved into the file as an HEIC image. The pin will
    /// contain a path reference to this image so that it remains persistent.
    ///
    /// - Parameter data: The data representation of the player-selected image to upload.
    /// - Parameter completion: A completion handler that executes when the image has been uploaded.
    func uploadImage(_ data: Data, completion: (() -> Void)? = nil) {
        let imageName = UUID().uuidString + ".heic"
        file.wrappedValue.images[imageName] = data
        if file.wrappedValue.pins[index].images == nil {
            file.wrappedValue.pins[index].images = [imageName]
        } else {
            file.wrappedValue.pins[index].images?.insert(imageName)
        }
        completion?()
    }
}

#if DEBUG
    extension CartographyPinViewModel {
        var testHooks: TestHooks { TestHooks(target: self) }

        struct TestHooks {
            private let target: CartographyPinViewModel

            fileprivate init(target: CartographyPinViewModel) {
                self.target = target
            }

            var file: Binding<CartographyMapFile> {
                target.file
            }

            var index: Int {
                target.index
            }
        }
    }
#endif
