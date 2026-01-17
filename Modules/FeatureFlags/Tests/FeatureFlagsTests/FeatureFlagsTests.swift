//
//  FeatureFlagTests.swift
//  MCMaps
//
//  Created by Marquis Kurt on 24-06-2025.
//

import Foundation
import Testing

@testable import FeatureFlags

struct FeatureFlagTests {
    @Test(.disabled("No new feature flags"))
    func flagDefaultValues() async throws {
//        if #available(iOS 19, macOS 16, *) {
//            #expect(FeatureFlag.redWindow.isEnabledByDefault == true)
//        } else {
//            #expect(FeatureFlag.redWindow.isEnabledByDefault == false)
//        }
    }

    @Test(.disabled("No new feature flags"))
    func flagPropertyWrapper() async throws {
//        let defaults = UserDefaults(suiteName: "net.marquiskurt.mcmaps.testing") ?? UserDefaults()
//        defaults.set(true, forKey: FeatureFlag.redWindow.keyName)
//
//        @FeatureFlagged(.redWindow, store: defaults) var redWindow
//        #expect(redWindow == true)
//
//        redWindow = false
//        #expect(defaults.bool(forFeatureFlag: .redWindow) == false)
    }
}
