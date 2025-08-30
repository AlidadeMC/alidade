//
//  EnvironmentExtensions.swift
//  MCMaps
//
//  Created by Marquis Kurt on 13-07-2025.
//

import SwiftUI

extension EnvironmentValues {
    /// The network service that fetches data from Bluemap.
    @Entry var bluemapService: CartographyBluemapService?

    /// The URL for the current document.
    @Entry var documentURL: URL?

    /// The current clock handler.
    @Entry var clock = CartographyClock()
}
