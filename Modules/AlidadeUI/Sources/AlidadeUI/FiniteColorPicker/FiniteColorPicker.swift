//
//  FiniteColorPicker.swift
//  AlidadeUI
//
//  Created by Marquis Kurt on 26-05-2025.
//

import SwiftUI

/// A view used to pick a set of finite colors.
///
/// The finite color picker works like a standard picker, where its values consist of SwiftUI colors. This is generally
/// used to force a user to pick from a small palette of colors instead of an arbitrary color:
///
/// ```swift
/// import AlidadeUI
/// import SwiftUI
///
/// struct MyPicker: View {
///     @State private var color = Color.blue
///     let availableColors = [Color.red, Color.green, Color.blue]
///
///     var body: some View {
///         FiniteColorPicker("Car Color", selection: $color, in: availableColors)
///             .colorStyle(.automatic)
///     }
/// }
/// ```
public struct FiniteColorPicker: View {
    /// An enumeration representing the color styles of a finite color picker.
    public enum ColorStyle {
        /// The plain color style.
        case plain

        /// The gradient color style.
        case gradient

        /// The automatic color style.
        ///
        /// Styling is determined automatically based on the platform.
        case automatic
    }

    private enum Constants {
        static let pinHeightMultiplier = 2.5
        #if os(macOS)
            static let pinColorSize = 20.0
        #else
            static let pinColorSize = 28.0
        #endif
    }

    @Binding var selection: Color

    var title: LocalizedStringKey
    var colors: [Color]
    var allowCustomSelection = false
    var colorStyle = ColorStyle.automatic

    /// Initialize a finite color picker.
    /// - Parameter titleKey: The title of the picker.
    /// - Parameter selection: The color being picked in the picker.
    /// - Parameter colors: The colors available to choose from in the picker.
    public init(_ titleKey: LocalizedStringKey, selection: Binding<Color>, in colors: [Color]) {
        self.title = titleKey
        self._selection = selection
        self.colors = colors
    }

    init(
        titleKey: LocalizedStringKey,
        selection: Binding<Color>,
        colors: [Color],
        allowCustomSelection: Bool,
        colorStyle: ColorStyle
    ) {
        self.title = titleKey
        self._selection = selection
        self.colors = colors
        self.allowCustomSelection = allowCustomSelection
        self.colorStyle = colorStyle
    }

    /// Allow a custom selector using a standard color picker as the last option.
    /// - Parameter isActive: Whether the modifier takes effect.
    public func includeCustomSelection(isActive: Bool = true) -> Self {
        FiniteColorPicker(
            titleKey: self.title,
            selection: self.$selection,
            colors: self.colors,
            allowCustomSelection: isActive,
            colorStyle: self.colorStyle)
    }

    /// Configures the color style for the color buttons.
    /// - Parameter style: The color style to configure the picker with.
    public func colorStyle(_ style: ColorStyle) -> Self {
        FiniteColorPicker(
            titleKey: self.title,
            selection: self.$selection,
            colors: self.colors,
            allowCustomSelection: self.allowCustomSelection,
            colorStyle: style)
    }

    public var body: some View {
        HStack {
            Text(title)
            ForEach(colors, id: \.description) { color in
                ColorChoiceButton(selection: $selection, color: color, colorStyle: colorStyle)
                    .tag(color)
            }
            if allowCustomSelection {
                ColorPicker("", selection: $selection)
                    .frame(width: Constants.pinColorSize, height: Constants.pinColorSize)
            }
        }
    }
}

#Preview {
    @Previewable @State var currentColor = Color.blue
    let allowedColors = [Color.red, Color.yellow, Color.green, Color.blue]

    Form {
        Section {
            FiniteColorPicker("Racecar Color:", selection: $currentColor, in: allowedColors)
        } header: {
            Text("Standard Color Picker, Automatic Style")
        } footer: {
            Text("Automatic styling is inferred from the platform.")
        }
        Section {
            FiniteColorPicker("Racecar Color:", selection: $currentColor, in: allowedColors)
                .colorStyle(.gradient)
        } header: {
            Text("Standard Color Picker, Gradient Style")
        }
        Section {
            FiniteColorPicker("Racecar Color:", selection: $currentColor, in: allowedColors)
                .colorStyle(.plain)
        } header: {
            Text("Standard Color Picker, Plain Style")
        }
        Section {
            FiniteColorPicker("Racecar Color:", selection: $currentColor, in: allowedColors)
                .includeCustomSelection()
        } header: {
            Text("Color Picker with Custom Selector")
        }

    }
}
