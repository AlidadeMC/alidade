import CubiomesInternal
import Foundation
import SnapshotTesting
import Testing

@testable import CubiomesKit

extension Data {
    var bytes: [UInt8] { return [UInt8](self) }
}

struct MinecraftWorldTests {
    @Test func worldGeneratorRespectsVersion() async throws {
        let world = try MinecraftWorld(version: "1.2", seed: 123)
        let generator = world.generator()
        #expect(generator.mc == MC_1_2.rawValue)
        #expect(generator.seed == 123)
    }

    @Test func snapshotMatchesOriginalImage() async throws {
        let mcWorld = try MinecraftWorld(version: "1.21", seed: 3_257_840_388_504_953_787)
        let data = mcWorld.snapshot(
            in: .init(
                origin: .init(x: 116, y: 15, z: -31),
                scale: .init(x: 256, y: 1, z: 256)),
            dimension: .overworld)
        assertSnapshot(data: data, testBundleResourceURL: Bundle.module.resourceURL!)
    }

    @Test func worldInitStopsWithInvalidVersion() async throws {
        #expect(throws: MinecraftWorld.WorldError.invalidVersionNumber) {
            try MinecraftWorld(version: "lorelei", seed: 123)
        }
    }
}
