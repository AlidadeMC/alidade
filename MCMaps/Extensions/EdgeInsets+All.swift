//
//  EdgeInsets+All.swift
//  MCMaps
//
//  Created by Marquis Kurt on 19-02-2025.
//

import SwiftUI

extension EdgeInsets {
    /// An edge inset where all insets are set to zero.
    static let zero = EdgeInsets(all: 0)

    /// Creates edge insets that all match a specific value.
    /// - Parameter all: The value that all insets should be set to.
    init(all: CGFloat) {
        self.init(top: all, leading: all, bottom: all, trailing: all)
    }
}
