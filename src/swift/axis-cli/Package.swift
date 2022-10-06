// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "axis-cli",
    platforms: [
        .macOS(.v12)
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-argument-parser.git", from: "1.0.0"),
        .package(url: "https://github.com/vapor/fluent-kit.git", from: "1.35.1"),
        // .package(url: "https://github.com/vapor/sqlite-kit.git", from: "4.1.0"),
        .package(url: "https://github.com/vapor/fluent-sqlite-driver.git", from: "4.0.0"),
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .executableTarget(
            name: "axis-cli",
            dependencies: [
                .product(name: "ArgumentParser", package: "swift-argument-parser"),
                .product(name: "FluentKit", package: "fluent-kit"),
                // .product(name: "FluentSQL", package: "fluent-kit"),
                // .product(name: "SQLiteKit", package: "sqlite-kit"),
                .product(name: "FluentSQLiteDriver", package: "fluent-sqlite-driver"),
            ]),
        .testTarget(
            name: "axis-cliTests",
            dependencies: ["axis-cli"]),
    ]
)
