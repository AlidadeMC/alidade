//
//  UserDefaults+Keys.swift
//  MCMaps
//
//  Created by Marquis Kurt on 23-03-2025.
//

import Foundation
import SwiftUI

extension UserDefaults {
    enum Keys: String, Sendable {
        @available(macOS 26, *)
        case generalMacSearchAutofocus = "general.searchAutoFocus"

        case mapNaturalColors = "map.naturalColors"
        case mapCoordinateIndicator = "map.coordinateIndicator"

        case generalAppearance = "general.colorScheme"
    }

    func valueExists(forKey key: Keys) -> Bool {
        self.value(forKey: key.rawValue) != nil
    }

    func bool(forKey key: Keys) -> Bool {
        self.bool(forKey: key.rawValue)
    }

    func string(forKey key: Keys) -> String {
        self.string(forKey: key.rawValue) ?? ""
    }

    func set(_ value: Bool, forKey key: Keys) {
        self.set(value, forKey: key.rawValue)
    }

    func set(_ value: String, forKey key: Keys) {
        self.set(value, forKey: key.rawValue)
    }
}
