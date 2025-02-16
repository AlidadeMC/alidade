//
//  CGPoint+Manhattan.swift
//  MCMaps
//
//  Created by Marquis Kurt on 16-02-2025.
//

import Foundation

extension CGPoint {
    func manhattanDistance(to other: CGPoint) -> Double {
        let deltaX = self.x - other.x
        let deltaY = self.y - other.y
        return abs(deltaX) + abs(deltaY)
    }
}
