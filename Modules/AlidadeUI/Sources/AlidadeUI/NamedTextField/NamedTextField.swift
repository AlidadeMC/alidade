//
//  NamedTextField.swift
//  AlidadeUI
//
//  Created by Marquis Kurt on 15-07-2025.
//

import SwiftUI

/// A text field in which its title or name is always displayed.
///
/// Some container view types such as `Form` may hide the title label. For instances where the title should always be
/// visible, this view can be used in place of a standard `TextField` component:
///
/// ```
/// import AlidadeUI
/// import SwiftUI
///
/// struct MyForm: View {
///     @State private var text = ""
///     var body: some View {
///         Form {
///             NamedTextField("Foo", text: $text)
///         }
///         .formStyle(.grouped)
///     }
/// }
/// ```
public struct NamedTextField: View {
    @Environment(\.isEnabled) private var isEnabled

    var title: LocalizedStringKey
    @Binding var text: String

    /// Create a named text field from a localized string key and text.
    /// - Parameter title: The text field's title.
    /// - Parameter text: The text that will be edited by the text field.
    public init(_ title: LocalizedStringKey, text: Binding<String>) {
        self.title = title
        self._text = text
    }

    /// Create a named text field from a string value and text.
    /// - Parameter string: The text field's title.
    /// - Parameter text: The text that will be edited by the text field.
    public init(_ string: String, text: Binding<String>) {
        self.title = LocalizedStringKey(stringLiteral: string)
        self._text = text
    }

    public var body: some View {
        #if os(macOS)
            TextField(title, text: $text)
        #else
            LabeledContent(title) {
                TextField(title, text: $text)
                    .foregroundStyle(isEnabled ? Color.primary : Color.secondary)
            }
        #endif
    }
}

#Preview {
    @Previewable @State var text = "foo"
    Form {
        NamedTextField("Name", text: $text)
    }
    .formStyle(.grouped)
}
