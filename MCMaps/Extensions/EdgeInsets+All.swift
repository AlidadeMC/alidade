//
//  EdgeInsets+All.swift
//  MCMaps
//
//  Created by Marquis Kurt on 19-02-2025.
//

import SwiftUI

extension EdgeInsets {
    static let zero = EdgeInsets(all: 0)

    init(all: CGFloat) {
        self.init(top: all, leading: all, bottom: all, trailing: all)
    }
}
