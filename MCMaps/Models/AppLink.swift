//
//  AppLink.swift
//  MCMaps
//
//  Created by Marquis Kurt on 30-03-2025.
//

import Foundation

enum AppLink: String {
    case help = "https://docs.alidade.dev/documentation/alidade/userguide"
    case github = "https://github.com/alicerunsonfedora/mcmaps"
    case issues = "https://github.com/alicerunsonfedora/mcmaps/issues"
    case docs = "https://docs.alidade.dev/documentation/alidade"
}

extension URL {
    init?(appLink: AppLink) {
        self.init(string: appLink.rawValue)
    }
}
