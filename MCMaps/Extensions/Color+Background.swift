//
//  Color+Background.swift
//  MCMaps
//
//  Created by Marquis Kurt on 02-02-2025.
//

import SwiftUI

extension Color {
    #if os(iOS)
        /// A color that corresponds to the system background (`UIColor.systemBackground`).
        static var systemBackground: Color = Color(uiColor: .systemBackground)
    #endif
}
