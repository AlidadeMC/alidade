//
//  FeatureFlagPropertyWrapper.swift
//  MCMaps
//
//  Created by Marquis Kurt on 14-06-2025.
//

import SwiftUI

@propertyWrapper
struct FeatureFlagged {
    var flag: FeatureFlag

    var wrappedValue: Bool {
        get { UserDefaults.standard.bool(forFeatureFlag: flag) }
        set { UserDefaults.standard.setValue(newValue, forFeatureFlag: flag) }
    }

    init(_ flag: FeatureFlag) {
        self.flag = flag
    }
}
