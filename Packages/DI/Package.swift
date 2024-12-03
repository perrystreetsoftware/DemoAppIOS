// swift-tools-version: 5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription
import CompilerPluginSupport

let package = Package(
    name: "DI",
    platforms: [.macOS(.v10_15), .iOS(.v13), .tvOS(.v13), .watchOS(.v6), .macCatalyst(.v13)],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "DI",
            targets: ["DI"]),
    ],
    dependencies: [
//        .package(url: "https://github.com/apple/swift-syntax.git", from: "509.0.0"),
        .package(url: "https://github.com/sjavora/swift-syntax-xcframeworks.git", from: "510.0.1"),
    ],
    targets: [
//        // Targets are the basic building blocks of a package, defining a module or a test suite.
//        // Targets can depend on other targets in this package and products from dependencies.
        .macro(
            name: "DIMacros",
            dependencies: [
//                .product(name: "SwiftSyntaxMacros", package: "swift-syntax"),
//                .product(name: "SwiftCompilerPlugin", package: "swift-syntax")
                .product(name: "SwiftSyntaxWrapper", package: "swift-syntax-xcframeworks")
            ]
        ),
//
//        // Library that exposes a macro as part of its API, which is used in client programs.
        .target(name: "DI", dependencies: ["DIMacros"]),
        .testTarget(
            name: "DITests",
            dependencies: [
                "DIMacros",
//                .product(name: "SwiftSyntaxMacrosTestSupport", package: "swift-syntax"),
                .product(name: "SwiftSyntaxWrapper", package: "swift-syntax-xcframeworks"),
            ]
        ),
    ]
)
