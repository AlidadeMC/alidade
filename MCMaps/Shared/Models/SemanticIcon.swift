//
//  SemanticIcon.swift
//  MCMaps
//
//  Created by Marquis Kurt on 12-08-2025.
//

import SwiftUI

/// A typealias that represents the most basic SwiftUI label.
typealias BasicLabel = SwiftUI.Label<Text, Image>

/// An enumeration of the various semantic icons used in the app.
///
/// Semantic icons provide a consistent meaning across usage of the app, based on its intended purpose. Semantic icons
/// should be used wherever possible to ensure that actions remain consistent.
///
/// For example, to create an icon representing the Nether, the
/// ``SwiftUICore/Image/init(semanticIcon:variableValue:)`` initializer can be used:
///
/// ```swift
/// import SwiftUI
///
/// struct MyView: View {
///     var body: some View {
///         Image(semanticIcon: .nether)
///     }
/// }
/// ```
enum SemanticIcon: String {
    /// The player is intending to select a color.
    case colorSelect = "paintpalette"

    /// The player is intending to copy a piece of information.
    case copy = "document.on.document"

    /// The player is intending to make a customization.
    case customize = "paintbrush.pointed"

    /// The player is intending to select a world dimension.
    case dimensionSelect = "atom"

    /// The player is intending to go to a specific location.
    ///
    /// This can also be used to refer to a current location.
    case goHere = "location"

    /// The player is intending to select an icon.
    case iconSelect = "xmark.triangle.circle.square"

    /// An icon used to indicate an inspector in the app.
    case inspectorToggle = "sidebar.right"

    /// The icon representing the Overworld dimension.
    case overworld = "tree"

    /// The icon representing the Nether dimension.
    case nether = "flame"

    /// The icon representing the End dimension.
    case end = "sparkles"
}

extension Image {
    /// Create an image from a semantic icon.
    /// - Parameter semanticIcon: The semantic icon to use.
    /// - Parameter variableValue: The symbol's variable value.
    init(semanticIcon: SemanticIcon, variableValue: Double? = nil) {
        self.init(systemName: semanticIcon.rawValue, variableValue: variableValue)
    }
}

extension Label where Title == Text, Icon == Image {
    /// Create a label with a given title and semantic icon.
    /// - Parameter titleKey: The label's title.
    /// - Parameter semanticIcon: The semantic icon to use.
    init(_ titleKey: LocalizedStringKey, semanticIcon: SemanticIcon) {
        self.init(titleKey, systemImage: semanticIcon.rawValue)
    }

    /// Create a label with a given title and semantic icon.
    /// - Parameter title: The label's title.
    /// - Parameter semanticIcon: The semantic icon to use.
    init(_ title: String, semanticIcon: SemanticIcon) {
        self.init(title, systemImage: semanticIcon.rawValue)
    }
}

extension Button where Label == BasicLabel {
    /// Create a button with a label containing a semantic icon.
    /// - Parameter titleKey: The button's title.
    /// - Parameter semanticIcon: The semantic icon to use.
    /// - Parameter action: The action that will be performed when the player taps the button.
    init(_ titleKey: LocalizedStringKey, semanticIcon: SemanticIcon, perform action: @escaping () -> Void) {
        self.init(titleKey, systemImage: semanticIcon.rawValue, action: action)
    }
}
