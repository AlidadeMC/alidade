//
//  MCMapIntegration.swift
//  MCMapFormat
//
//  Created by Marquis Kurt on 12-07-2025.
//

import Foundation

public protocol MCMapIntegration: Codable, Sendable, Equatable, Hashable {
    static var integrationKey: String { get }

    var enabled: Bool { get set }
}
