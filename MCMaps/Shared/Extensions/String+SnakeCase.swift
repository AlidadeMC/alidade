//
//  String+SnakeCase.swift
//  MCMaps
//
//  Created by Marquis Kurt on 18-06-2025.
//

import Foundation

extension String {
    /// Retrieves a snake-case version of the current string.
    ///
    /// For example, if the current string is set to `"Red Window"`, this value will return `"red_window"`.
    var snakeCase: String {
        let components = self.components(separatedBy: " ").map(\.localizedLowercase)
        return components.joined(separator: "_")
    }
}
