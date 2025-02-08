//
//  Color+Background.swift
//  MCMaps
//
//  Created by Marquis Kurt on 02-02-2025.
//

import SwiftUI

extension Color {
    #if os(iOS)
        static var systemBackground: Color = Color(uiColor: .systemBackground)
    #endif
}
