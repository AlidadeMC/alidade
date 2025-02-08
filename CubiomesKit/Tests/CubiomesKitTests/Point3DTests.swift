//
//  Point3DTests.swift
//  CubiomesKit
//
//  Created by Marquis Kurt on 04-02-2025.
//

import CubiomesKit
import Foundation
import Testing

struct Point3DTests {
    @Test func initFromCGPoint() async throws {
        let point = CGPoint(x: 15, y: 15)
        let threeDPoint = Point3D<Int>(cgPoint: point)
        let threeDPoint_32Bit = Point3D<Int32>(cgPoint: point)

        #expect(threeDPoint == .init(x: 15, y: 1, z: 15))
        #expect(threeDPoint_32Bit == .init(x: 15, y: 1, z: 15))
    }
}
