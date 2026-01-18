// swift-tools-version: 6.0

import PackageDescription

let package = Package(
    name: "Testchamber",
    platforms: [.macOS(.v14), .iOS(.v17), .visionOS(.v1), .watchOS(.v10), .tvOS(.v17)],
    products: [
        .library(
            name: "Testchamber",
            targets: ["Testchamber"]
        )
    ],
    targets: [
        .target(
            name: "Testchamber"
        )
    ]
)
