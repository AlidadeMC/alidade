//
//  FeatureFlags.swift
//  MCMaps
//
//  Created by Marquis Kurt on 13-06-2025.
//

import Foundation

/// An enumeration representing the various feature flags in the app.
///
/// Feature flags are used to control specific features in the app during the development and testing phases. It is
/// typically reserved for experimental features that aren't guaranteed for a release. Use this in conjunction with
/// ``FeatureFlagged`` to read the value of feature flags:
///
/// ```swift
/// import SwiftUI
///
/// struct MyView: View {
///     @FeatureFlagged(.redWindow) private var useRedWindowDesign
/// }
/// ```
enum FeatureFlag {
}

extension FeatureFlag {
    /// The name of the key as stored in User Defaults.
    ///
    /// This should also correspond to the key used in the app's Settings bundle, whenever applicable.
    var keyName: String {
        ""
    }

    /// Whether the flag is enabled by default.
    var isEnabledByDefault: Bool {
        true
    }
}

extension UserDefaults {
    /// Retrieve the flag value for a specified feature flag, or the default value if it isn't already set.
    /// - Parameter flag: The flag to retrieve the value of.
    func bool(forFeatureFlag flag: FeatureFlag) -> Bool {
        guard let value = self.value(forKey: flag.keyName) as? Bool else {
            return flag.isEnabledByDefault
        }
        return value
    }

    /// Set the value for a feature flag.
    /// - Parameter value: Whether the feature flag is enabled.
    /// - Parameter flag: The feature flag to enable or disable.
    func setValue(_ value: Bool, forFeatureFlag flag: FeatureFlag) {
        self.setValue(value, forKey: flag.keyName)
    }
}
