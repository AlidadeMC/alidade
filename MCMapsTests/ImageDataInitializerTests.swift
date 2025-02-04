//
//  ImageDataInitializerTests.swift
//  MCMaps
//
//  Created by Marquis Kurt on 04-02-2025.
//

@testable import Alidade
import SwiftUI
import Testing

class Helper {}

struct ImageDataInitializerTests {
    @Test func imageConstructsWithData() async throws {
        guard let imagePath = Bundle(for: Helper.self).url(forResource: "map", withExtension: "ppm") else {
            Issue.record("Resource not found.")
            return
        }
        let data = try Data(contentsOf: imagePath)
        let image = Image(data: data)
        #expect(image != nil)
    }
}
