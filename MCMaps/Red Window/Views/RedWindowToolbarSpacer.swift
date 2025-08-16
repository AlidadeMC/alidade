//
//  RedWindowToolbarSpacer.swift
//  MCMaps
//
//  Created by Marquis Kurt on 16-08-2025.
//

import SwiftUI

struct RedWindowToolbarSpacer: ToolbarContent {
    var body: some ToolbarContent {
        #if RED_WINDOW
            if #available(macOS 16, iOS 19, *) {
                ToolbarSpacer(.fixed)
            } else {
                ToolbarItem { EmptyView() }
            }
        #else
        ToolbarItem { EmptyView() }
        #endif
    }
}
