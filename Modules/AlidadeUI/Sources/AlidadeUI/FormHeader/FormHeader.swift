//
//  FormHeader.swift
//  AlidadeUI
//
//  Created by Marquis Kurt on 15-07-2025.
//

import SwiftUI

/// A generic system icon for use with ``FormHeader``.
///
/// This view cannot be initialized on its own; to use this view for a form header, use the
/// ``FormHeader/init(systemImage:tint:title:description:)`` initializer.
public struct SystemIcon: View {
    /// The symbol image that should be displayed in this view.
    var systemImage: String

    /// The background color for icon.
    var backgroundColor: Color

    @ScaledMetric var baseSize = 1.0

    internal init(systemImage: String, backgroundColor: Color) {
        self.systemImage = systemImage
        self.backgroundColor = backgroundColor
    }

    public var body: some View {
        Image(systemName: systemImage)
            .resizable()
            .scaledToFit()
            .frame(width: 56 * baseSize, height: 56 * baseSize)
            .shadow(color: .secondary.opacity(0.5), radius: 1)
            .foregroundStyle(.white.gradient)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(backgroundColor.gradient)
    }
}

/// A view used to annotate a header section for a form.
///
/// Like the `ContentUnavailableView`, the form header is used to display a title, description, and accompanying image.
/// Use this view whenever you intend to provide information about the current form:
///
/// ```swift
/// import AlidadeUI
/// import SwiftUI
///
/// struct MyForm: View {
///     var body: some View {
///         Form {
///             Section {
///                 FormHeader(systemImage: "wifi") {
///                     Title("Wi-Fi")
///                 } description: {
///                     Text(...)
///                 }
///             }
///         }
///     }
/// }
/// ```
public struct FormHeader<Icon: View>: View {
    enum Constants {
        private static var useLeadingSettingsStyle: Bool {
            #if os(macOS)
            return false
            #else
            if #available(iOS 26.2, *) {
                return true
            } else {
                return false
            }
            #endif
        }
        static var alignment: HorizontalAlignment {
            Self.useLeadingSettingsStyle ? .leading : .center
        }

        static var textAlignment: TextAlignment {
            Self.useLeadingSettingsStyle ? .leading: .center
        }

        static var baseSize: CGFloat {
            Self.useLeadingSettingsStyle ? 64 : 76
        }
    }
    var icon: () -> Icon
    var title: () -> Text
    var description: () -> Text

    @ScaledMetric var baseSize = 1.0

    /// Initialize a form header view.
    /// - Parameter icon: The icon view that will be displayed at the top of the header.
    /// - Parameter title: The form header's title. Generally, this should be the name of the form or form section.
    /// - Parameter description: The form header's description.
    public init(icon: @escaping () -> Icon, title: @escaping () -> Text, description: @escaping () -> Text) {
        self.icon = icon
        self.title = title
        self.description = description
    }

    public var body: some View {
        #if os(macOS)
            centeredHeader
        #else
            if #available(iOS 26.2, *) {
                header
            } else {
                centeredHeader
            }
        #endif
    }

    var centeredHeader: some View {
        HStack {
            Spacer()
            header
                .padding(.vertical)
            Spacer()
        }
    }

    var header: some View {
        VStack(alignment: Constants.alignment) {
            icon()
                .scaledToFit()
                .frame(width: Constants.baseSize * baseSize, height: Constants.baseSize * baseSize)
                .clipped()
                .clipShape(RoundedRectangle(cornerRadius: 16))
            title()
                .font(.title2)
                .bold()
            description()
                .multilineTextAlignment(Constants.textAlignment)
                .foregroundStyle(.secondary)
        }
    }
}

extension FormHeader {
    /// Initialize a form header view with an image from an asset catalog.
    /// - Parameter name: The name of the image asset to use.
    /// - Parameter title: The form header's title. Generally, this should be the name of the form or form section.
    /// - Parameter description: The form header's description.
    public init(name: String, title: @escaping () -> Text, description: @escaping () -> Text) where Icon == Image {
        self.title = title
        self.description = description
        self.icon = {
            Image(name)
                .resizable()
        }
    }

    /// Initialize a form header view with a symbol image from SF Symbols.
    /// - Parameter systemImage: The name of the symbol to use.
    /// - Parameter tint: The background tint to use. Defaults to the app's accent color.
    /// - Parameter title: The form header's title. Generally, this should be the name of the form or form section.
    /// - Parameter description: The form header's description.
    public init(
        systemImage: String,
        tint: Color = .accentColor,
        title: @escaping () -> Text,
        description: @escaping () -> Text
    ) where Icon == SystemIcon {
        self.title = title
        self.description = description
        self.icon = {
            SystemIcon(systemImage: systemImage, backgroundColor: tint)
        }
    }
}

#Preview {
    Form {
        Section {
            FormHeader(systemImage: "wifi") {
                Text("Wi-Fi")
            } description: {
                Text(
                    "Connect to Wi-Fi, view available networks, and manage settings for joining networks and nearby hotspots. [Learn more...](https://example.com)"
                )
            }
        } header: {
            Text("System Image (Default Tint)")
        }

        Section {
            FormHeader(systemImage: "questionmark.circle", tint: .gray) {
                Text("Help")
            } description: {
                Text(
                    "Browse manuals and help guides to find and resolve your issue. [Learn more...](https://example.com)"
                )
            }
        } header: {
            Text("System Image (Custom Tint)")
        }

        Section {
            FormHeader {
                ProgressView()
            } title: {
                Text("Activities")
            } description: {
                Text(
                    "I am an old woman; I'm yesterday's news. I dream in black and white, and I see it all through laser eyes. [Learn more...](https://example.com)"
                )
            }
        } header: {
            Text("Custom Icon View")
        }
    }
    .formStyle(.grouped)
}
