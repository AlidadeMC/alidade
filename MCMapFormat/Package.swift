// swift-tools-version: 6.0

import PackageDescription

let package = Package(
    name: "MCMapFormat",
    platforms: [.macOS(.v15), .iOS(.v18), .tvOS(.v18), .watchOS(.v11), .visionOS(.v2)],
    products: [
        .library(
            name: "MCMapFormat",
            targets: ["MCMapFormat"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/jrothwell/VersionedCodable.git", from: "1.1.0")
    ],
    targets: [
        .target(
            name: "MCMapFormat",
            dependencies: ["VersionedCodable"]
        ),
        .testTarget(
            name: "MCMapFormatTests",
            dependencies: ["MCMapFormat"]
        ),
    ]
)
