//
//  PPMDataTests.swift
//  CubiomesKit
//
//  Created by Marquis Kurt on 15-02-2025.
//

import CubiomesKit
import Foundation
import Testing

struct PPMDataTests {
    @Test func dataInitializer() async throws {
        let expectedContent =
            """
            P6
            2 2
            255
            0 0 0  0 0 0
            0 0 0  0 0 0
            """

        let pixelArray: [Character] = [
            "0", " ", "0", " ", "0", " ", " ", "0", " ", "0", " ", "0", "\n",
            "0", " ", "0", " ", "0", " ", " ", "0", " ", "0", " ", "0",
        ]
        let obj = PPMData(
            pixels: pixelArray.compactMap { char in
                guard let ascii = char.asciiValue else { return nil }
                let scalar = UnicodeScalar(ascii)
                return CUnsignedChar(ascii: scalar)

            }, size: .init(width: 2, height: 2))
        let data = Data(ppm: obj)
        guard let string = String(data: data, encoding: .utf8) else {
            Issue.record("Data produced isn't a string value!")
            return
        }
        #expect(string == expectedContent)
    }
}
