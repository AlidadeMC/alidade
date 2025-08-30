//
//  UserDefaults+Keys.swift
//  MCMaps
//
//  Created by Marquis Kurt on 23-03-2025.
//

import Foundation

extension UserDefaults {
    enum Keys: String, Sendable {
        case mapNaturalColors = "map.naturalColors"
    }

    func valueExists(forKey key: Keys) -> Bool {
        self.value(forKey: key.rawValue) != nil
    }

    func bool(forKey key: Keys) -> Bool {
        self.bool(forKey: key.rawValue)
    }

    func set(_ value: Bool, forKey key: Keys) {
        self.set(value, forKey: key.rawValue)
    }
}
