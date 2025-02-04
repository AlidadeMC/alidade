// swift-tools-version: 6.0

import PackageDescription

private let wrapIntegers = CSetting.unsafeFlags(["-fwrapv"])

let package = Package(
    name: "CubiomesKit",
    products: [
        .library(
            name: "CubiomesKit",
            targets: ["CubiomesKit"]),
    ],
    targets: [
        .target(
            name: "Cubiomes",
            exclude: ["docs", "tests.c"],
            publicHeadersPath: ".",
            cSettings: [wrapIntegers]),
        .target(
            name: "CubiomesInternal",
            dependencies: ["Cubiomes"],
            publicHeadersPath: ".",
            cSettings: [wrapIntegers]),
        .target(
            name: "CubiomesKit",
            dependencies: ["Cubiomes", "CubiomesInternal"]),
        .testTarget(
            name: "CubiomesKitTests",
            dependencies: ["CubiomesKit"],
            resources: [
                .process("Resources")
            ]
        ),
    ]
)
