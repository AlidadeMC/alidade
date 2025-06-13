//
//  MCMapsApp+AppProperties.swift
//  MCMaps
//
//  Created by Marquis Kurt on 13-06-2025.
//

import SwiftUI

extension MCMapsApp {
    /// The app's display name as it appears in the Info.plist file.
    static var appName: String {
        Bundle.main.infoDictionary?["CFBundleDisplayName"] as? String ?? ""
    }

    /// The app's main version as it appears in the Info.plist file.
    static var version: String {
        Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "0.0"
    }

    /// The app's build number as it appears in the Info.plist file.
    static var buildNumber: String {
        Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "0"
    }

    static var copyrightString: String {
        Bundle.main.infoDictionary?["NSHumanReadableCopyright"] as? String ?? ""
    }
}
