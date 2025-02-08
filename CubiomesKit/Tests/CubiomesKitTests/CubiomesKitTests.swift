import Foundation
import Testing

@testable import CubiomesKit

@Test func snapshotMatchesOriginalImage() async throws {
    guard let originalDataPath = Bundle.module.path(forResource: "map", ofType: "ppm") else {
        Issue.record("Snapshot can't be found.")
        return
    }
    let originalData = try Data(contentsOf: .init(filePath: originalDataPath))
    let mcWorld = try MinecraftWorld(version: "1.2", seed: 3_257_840_388_504_953_787)
    let data = mcWorld.snapshot(
        in: .init(
            origin: .init(x: 116, y: 15, z: -31),
            scale: .init(x: 256, y: 1, z: 256)),
        dimension: .overworld)

    #expect(data == originalData)
}

@Test func worldInitStopsWithInvalidVersion() async throws {
    #expect(throws: MinecraftWorld.WorldError.invalidVersionNumber) {
        try MinecraftWorld(version: "lorelei", seed: 123)
    }
}
