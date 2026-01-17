//
//  InlineBannerVariant+Accessibility.swift
//  AlidadeUI
//
//  Created by Marquis Kurt on 26-05-2025.
//

import SwiftUI

extension InlineBanner.Variant {
    var accessibilityLabel: LocalizedStringKey {
        switch self {
        case .information:
            "Info"
        case .success:
            "Success"
        case .warning:
            "Warning"
        case .error:
            "Error"
        }
    }
}
