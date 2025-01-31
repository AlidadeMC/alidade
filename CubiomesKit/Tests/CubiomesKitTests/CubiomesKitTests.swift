import Testing
import Foundation
@testable import CubiomesKit

@Test func example() async throws {
    // Write your test here and use APIs like `#expect(...)` to check expected conditions.
    let currentPath = FileManager.default.currentDirectoryPath
    let mcWorld = MinecraftWorld(version: "1.2", seed: 3257840388504953787)
    let data = mcWorld.snapshot(
        in: .init(
            origin: .init(x: 116, 15, z: -31),
            scale: .init(x: 256, y: 1, z: 256)),
        dimension: .nether)

    let url = URL(filePath: currentPath + "/map.ppm")
    try data?.write(to: url)
}
