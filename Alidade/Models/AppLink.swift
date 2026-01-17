//
//  AppLink.swift
//  MCMaps
//
//  Created by Marquis Kurt on 30-03-2025.
//

import Foundation

/// An enumeration representing various app links.
enum AppLink: String {
    /// The link to the app user guide.
    case help = "https://docs.alidade.dev/documentation/alidade/userguide"

    /// The link to the source code.
    case github = "https://source.marquiskurt.net/AlidadeMC/Alidade"

    /// The link to the bug reporter.
    case issues = "https://youtrack.marquiskurt.net/youtrack/newIssue?project=ALD&c=add+Board+Alidade+Kanban+Board"

    /// The link to the app's document.
    case docs = "https://docs.alidade.dev/documentation/alidade"
}

extension URL {
    /// Create a URL from an app link.
    /// - Parameter appLink: The app link to create a URL from.
    init?(appLink: AppLink) {
        self.init(string: appLink.rawValue)
    }
}
