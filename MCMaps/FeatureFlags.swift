//
//  FeatureFlags.swift
//  MCMaps
//
//  Created by Marquis Kurt on 13-06-2025.
//

import Foundation

/// An enumeration representing the various feature flags in the app.
enum FeatureFlag {
    /// The feature flag associated with the new Liquid Glass design system.
    case redWindow
}

extension FeatureFlag {
    var keyName: String {
        switch self {
        case .redWindow: return "flags.red_window"
        }
    }

    var isEnabledByDefault: Bool {
        switch self {
        case .redWindow: return if #available(macOS 26, *) { true } else { false }
        }
    }
}

extension UserDefaults {
    func bool(forFeatureFlag flag: FeatureFlag) -> Bool {
        guard let value = self.value(forKey: flag.keyName) as? Bool else {
            return flag.isEnabledByDefault
        }
        return value
    }

    func setValue(_ value: Bool, forFeatureFlag flag: FeatureFlag) {
        self.setValue(value, forKey: flag.keyName)
    }
}
