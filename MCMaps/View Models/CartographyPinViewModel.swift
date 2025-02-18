//
//  CartographyPinViewModel.swift
//  MCMaps
//
//  Created by Marquis Kurt on 18-02-2025.
//

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
/// > to update pins in-place, assuming its index in the ``CartographyMap/pins`` list is stable.
class CartographyPinViewModel {
    private var file: Binding<CartographyMapFile>
    private var index: Int

    /// The pin that will be edited through this view model.
    ///
    /// Changes to this property will automatically propagate to the file.
    var pin: Binding<CartographyMapPin>

    /// A label that can be used to describe the pin's current position.
    var pinLocationLabel: String {
        let location = pin.wrappedValue.position
        return "(\(Int(location.x)), \(Int(location.y)))"
    }

    /// Creates a view model from a file and given index.
    /// - Parameter file: The file that will be modified.
    /// - Parameter index: The location where the pin is found.
    init(file: Binding<CartographyMapFile>, index: Int) {
        self.file = file
        self.index = index
        self.pin = .init {
            return file.wrappedValue.map.pins[index]
        } set: { newPin in
            file.wrappedValue.map.pins[index] = newPin
        }
    }

    /// Retrieves data blobs for the images associated with this pin.
    ///
    /// Images consist of user-uploaded screenshots that can be displayed alongside pins.
    func images() -> [Data] {
        return []
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
