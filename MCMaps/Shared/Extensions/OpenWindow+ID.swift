//
//  OpenWindow+ID.swift
//  MCMaps
//
//  Created by Marquis Kurt on 16-07-2025.
//

import SwiftUI

enum WindowID: String {
    case gallery, about, launch
}

extension OpenWindowAction {
    func callAsFunction<T: Codable & Hashable>(id: WindowID, context: T) {
        self.callAsFunction(id: id.rawValue, value: context)
    }

    func callAsFunction(id: WindowID) {
        self.callAsFunction(id: id.rawValue)
    }
}
