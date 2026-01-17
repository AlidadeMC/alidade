//
//  InlineBanner.swift
//  AlidadeUI
//
//  Created by Marquis Kurt on 26-05-2025.
//

import DesignLibrary
import SwiftUI

/// A view that displays a banner inline with other content.
///
/// The inline banner is used to display important messaging alongside other content. When embedded in a list or form,
/// it will automatically update the background color of its container.
///
/// ```swift
/// import AlidadeUI
/// import SwiftUI
///
/// struct MyForm: View {
///     var body: some View {
///         Form {
///             ...
///
///             InlineBanner(
///                 "Out of cloud credits",
///                 message: "Visit the account dashboard for more information.")
///                     .variant(.error)
///         }
///     }
/// }
/// ```
public struct InlineBanner: View {
    @Environment(\.colorScheme) private var colorScheme

    /// An enumeration representing the variants of an inline banner.
    public enum Variant: Sendable {
        /// The information variant.
        ///
        /// Use this variant to display general informative messages that do not provide any sentiment.
        case information

        /// The success variant.
        ///
        /// Use this variant to display messages that indicate something has succeeded.
        case success

        /// The warning variant.
        ///
        /// Use this variant to warn users and to take action.
        case warning

        /// The error variant.
        ///
        /// Use this variant to display message that indicate an action has failed, or something critical has occurred.
        case error
    }

    var title: LocalizedStringKey
    var message: LocalizedStringKey
    var variant: Variant = .information

    /// Initialize an inline banner.
    /// - Parameter titleKey: The title of the banner message.
    /// - Parameter message: The message or additional content used to provide context.
    public init(_ titleKey: LocalizedStringKey, message: LocalizedStringKey) {
        self.title = titleKey
        self.message = message
    }

    init(title: LocalizedStringKey, message: LocalizedStringKey, variant: Variant) {
        self.title = title
        self.message = message
        self.variant = variant
    }

    /// Configure the variant for the inline banner.
    /// - Parameter variant: The variant to configure the inline banner with.
    public func inlineBannerVariant(_ variant: Variant) -> Self {
        InlineBanner(title: self.title, message: self.message, variant: variant)
    }

    public var body: some View {
        Label {
            Text(title)
                .font(.headline)
            Text(message)

        } icon: {
            Image(systemName: systemImage)
                .bold()
                .font(.headline)
        }
        .labelStyle(.inlineBanner)
        #if os(macOS)
        .padding()
        .background(RoundedRectangle(cornerRadius: 4).fill(backgroundColor))
        #else
        .background(backgroundColor)
        #endif
        .foregroundStyle(foregroundColor)
        .listRowBackground(backgroundColor)
        .accessibilityElement(children: .combine)
        .accessibilityValue(variant.accessibilityLabel)
    }

    var systemImage: String {
        switch variant {
        case .information:
            "info.circle"
        case .success:
            "checkmark.circle"
        case .warning:
            "exclamationmark.triangle"
        case .error:
            "exclamationmark.circle"
        }
    }

    var backgroundColor: Color {
        switch variant {
        case .information:
            SemanticColors.Alert.infoBackground.resolve(with: colorScheme)
        case .success:
            SemanticColors.Alert.successBackground.resolve(with: colorScheme)
        case .warning:
            SemanticColors.Alert.warningBackground.resolve(with: colorScheme)
        case .error:
            SemanticColors.Alert.errorBackground.resolve(with: colorScheme)
        }
    }

    var foregroundColor: Color {
        switch variant {
        case .information:
            SemanticColors.Alert.infoForeground.resolve(with: colorScheme)
        case .success:
            SemanticColors.Alert.successForeground.resolve(with: colorScheme)
        case .warning:
            SemanticColors.Alert.warningForeground.resolve(with: colorScheme)
        case .error:
            SemanticColors.Alert.errorForeground.resolve(with: colorScheme)
        }
    }
}

#Preview {
    Form {
        Section {
            InlineBanner("The door is locked.",
                message: "Provide the correct `code` to _unlock_ this door, Signorina.")
            .inlineBannerVariant(.information)
        } header: {
            Text("Inline Banner, Information")
        }
        Section {
            InlineBanner("Truth recovered",
                message: "This is as **close** to the truth as we will ever get, Signorina.")
            .inlineBannerVariant(.success)
        } header: {
            Text("Inline Banner, Success")
        }
        Section {
            InlineBanner("Here be maze men",
                message: "Moments not saved will be lost to time.")
            .inlineBannerVariant(.warning)
        } header: {
            Text("Inline Banner, Warning")
        }
        Section {
            InlineBanner("Out of cloud credits",
                message: "Contact your administrator for more details, Signorina.")
            .inlineBannerVariant(.error)
        } header: {
            Text("Inline Banner, Error")
        }
    }
}
