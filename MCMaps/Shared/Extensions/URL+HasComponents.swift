//
//  URL+HasComponents.swift
//  MCMaps
//
//  Created by Marquis Kurt on 01-03-2025.
//

import Foundation

extension URL {
    func contains(components: [String]) -> Bool {
        for component in components {
            if !self.pathComponents.contains(component) { // swiftlint:disable:this for_where
                return false
            }
        }
        return true
    }
}
