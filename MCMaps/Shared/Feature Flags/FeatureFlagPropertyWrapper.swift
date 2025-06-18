//
//  FeatureFlagPropertyWrapper.swift
//  MCMaps
//
//  Created by Marquis Kurt on 14-06-2025.
//

import SwiftUI

/// A property wrapper used to retrieve and store feature flag values in user defaults.
@propertyWrapper
struct FeatureFlagged {
    /// The feature flag being read from or written to.
    var flag: FeatureFlag

    /// The user defaults storage to interact with. Defaults to the standard user defaults.
    var store: UserDefaults = .standard

    var wrappedValue: Bool {
        get { store.bool(forFeatureFlag: flag) }
        set { store.setValue(newValue, forFeatureFlag: flag) }
    }

    /// Create a feature flagged value.
    /// - Parameter flag: The flag to read from and/or write to.
    /// - Parameter store: The user defaults storage to interact with. Defaults to the standard user defaults.
    init(_ flag: FeatureFlag, store: UserDefaults = .standard) {
        self.flag = flag
        self.store = store
    }
}
