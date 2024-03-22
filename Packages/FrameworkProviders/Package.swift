// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "FrameworkProviders",
    platforms: [
        .iOS(.v14), .macOS(.v11)
    ],
    products: [
        .library(
            name: "FrameworkProviders",
            targets: ["FrameworkProviders"]),
        .library(
            name: "FrameworkProvidersProtocols",
            targets: ["FrameworkProvidersProtocols"]),
        .library(
            name: "FrameworkProvidersMocks",
            targets: ["FrameworkProvidersMocks"]),
    ],
    dependencies: [
        .package(path: "../Utils"),
        .package(url: "https://github.com/Swinject/Swinject.git", from: "2.7.1"),
        .package(url: "https://github.com/Swinject/SwinjectAutoregistration.git", from: "2.8.1"),
        .package(url: "https://github.com/Quick/Quick.git", from: "7.4.0"),
        .package(url: "https://github.com/Quick/Nimble.git", from: "13.2.0"),
        .package(url: "https://github.com/groue/CombineExpectations.git", from: "0.0.0"),
        .package(url: "https://github.com/SDWebImage/SDWebImageSVGCoder.git", from: "1.4.0"),
    ],
    targets: [
        .target(
            name: "FrameworkProviders",
            dependencies: [
                "FrameworkProvidersProtocols",
                "Swinject",
            ]),
        .target(
            name: "FrameworkProvidersProtocols",
            dependencies: []),
        .target(
            name: "FrameworkProvidersMocks",
            dependencies: [
                "Utils",
                "FrameworkProvidersProtocols"
            ]),
        .testTarget(
            name: "FrameworkProvidersTests",
            dependencies: [
                "FrameworkProviders",
                "FrameworkProvidersMocks",
                "Quick",
                "Nimble",
                "CombineExpectations",
            ])
    ]
)
