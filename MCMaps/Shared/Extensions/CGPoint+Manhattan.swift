//
//  CGPoint+Manhattan.swift
//  MCMaps
//
//  Created by Marquis Kurt on 16-02-2025.
//

import Foundation

extension CGPoint {
    /// A human-readable readout for accessibility purposes.
    var accessibilityReadout: String {
        let xVal = Int(x)
        let yVal = Int(y)
        return String(localized: "\(xVal), \(yVal)")
    }

    /// Rounds the components of the point.
    /// - Parameter rule: The rule to use when rounding. Defaults to `.toNearestOrAwayFromZero`.
    func rounded(_ rule: FloatingPointRoundingRule = .toNearestOrAwayFromZero) -> Self {
        CGPoint(x: self.x.rounded(rule), y: self.y.rounded(rule))
    }
}
