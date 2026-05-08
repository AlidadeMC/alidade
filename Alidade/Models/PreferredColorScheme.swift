//
//  PreferredColorScheme.swift
//  Alidade
//
//  Created by Marquis Kurt on 08-05-2026.
//

import SwiftUI

enum PreferredColorScheme: String, Hashable, CaseIterable {
    case automatic, light, dark

    var readableName: String {
        switch self {
        case .automatic: String(localized: "Use system appearance")
        case .light: String(localized: "Light")
        case .dark: String(localized: "Dark")
        }
    }
}

extension ColorScheme {
    init?(preferredColorScheme colorScheme: PreferredColorScheme) {
        switch colorScheme {
        case .light:
            self = .light
        case .dark:
            self = .dark
        default:
            return nil
        }
    }
}
