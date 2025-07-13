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
}
