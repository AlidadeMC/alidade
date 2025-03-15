// swift-tools-version: 6.0

import PackageDescription

// Allow integers to wrap to mimic Java behaviors.
private let wrapIntegers = CSetting.unsafeFlags(["-fwrapv"])

// Ignore implicit conversions inside of Cubiomes, since this is upstream code.
private let ignoreCubiomes = [
    "-Wno-implicit-int",
    "-Wno-implicit-function-declaration",
    "-Wno-conversion",
]

let package = Package(
    name: "CubiomesKit",
    platforms: [.macOS(.v13), .iOS(.v16), .visionOS(.v1), .watchOS(.v9)],
    products: [
        .library(
            name: "CubiomesKit",
            targets: ["CubiomesKit"])
    ],
    dependencies: [
//        .package(url: "https://github.com/pointfreeco/swift-snapshot-testing", from: "1.18.0")
    ],
    targets: [
        .target(
            name: "Cubiomes",
            exclude: ["docs", "tests.c"],
            publicHeadersPath: ".",
            cSettings: [wrapIntegers, .unsafeFlags(ignoreCubiomes)]),
        .target(
            name: "CubiomesInternal",
            dependencies: ["Cubiomes"],
            publicHeadersPath: ".",
            cSettings: [wrapIntegers, .unsafeFlags(ignoreCubiomes)]),
        .target(
            name: "CubiomesKit",
            dependencies: ["Cubiomes", "CubiomesInternal"],
            resources: [
                .process("Resources")
            ]),
        .testTarget(
            name: "CubiomesKitTests",
            dependencies: [
                "CubiomesKit",
//                .product(name: "SnapshotTesting", package: "swift-snapshot-testing"),
            ],
            resources: [
                .process("__Snapshots__")
            ]
        ),
    ]
)
