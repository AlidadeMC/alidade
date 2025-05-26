// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "AlidadeUI",
    platforms: [.macOS(.v15), .iOS(.v18)],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "AlidadeUI",
            targets: ["AlidadeUI"]),
    ],
    dependencies: [
        .package(url: "https://github.com/nalexn/ViewInspector", from: "0.10.0"),
        .package(name: "DesignLibrary", path: "DesignLibrary"),
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "AlidadeUI",
            dependencies: ["DesignLibrary"],
            resources: [
                .process("Resources")
            ]),
        .testTarget(
            name: "AlidadeUITests",
            dependencies: ["AlidadeUI", "ViewInspector"]
        ),
    ]
)
