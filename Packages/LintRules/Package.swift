// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "LintRules",
    platforms: [
        .iOS(.v16), .macOS(.v13)
    ],
    products: [
        .library(
            name: "LintRules",
            targets: ["LintRules"]
        ),
    ],
    dependencies: [
        .package(path: "../Utils"),
        .package(url: "https://github.com/perrystreetsoftware/harmonize.git", from: "0.6.0"),
        .package(url: "https://github.com/Quick/Quick.git", from: "7.0.2"),
    ],
    targets: [
        .target(
            name: "LintRules"
        ),
        .testTarget(
            name: "LintRulesTests",
            dependencies: [
                "LintRules",
                "Quick",
                .product(name: "Harmonize", package: "Harmonize"),
                .product(name: "UtilsTestExtensions", package: "Utils")
            ]
        ),
    ]
)
