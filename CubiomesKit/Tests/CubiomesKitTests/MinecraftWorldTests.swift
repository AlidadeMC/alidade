import CubiomesInternal
import Foundation
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

    @Test func worldInitStopsWithInvalidVersion() async throws {
        #expect(throws: MinecraftWorld.WorldError.invalidVersionNumber) {
            try MinecraftWorld(version: "lorelei", seed: 123)
        }
    }
}
