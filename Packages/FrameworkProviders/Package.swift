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
            name: "FrameworkProviderProtocols",
            targets: ["FrameworkProviderProtocols"]),
        .library(
            name: "FrameworkProviderFacades",
            targets: ["FrameworkProviderFacades"]),
        .library(
            name: "FrameworkProviderTestFactories",
            targets: ["FrameworkProviderTestFactories"]),
        .library(
            name: "FrameworkProviderMocks",
            targets: ["FrameworkProviderMocks"]),
    ],
    dependencies: [
        .package(path: "../Utils"),
        .package(path: "../DomainModels"),
        .package(url: "https://github.com/Swinject/Swinject.git", from: "2.7.1"),
        .package(url: "https://github.com/Swinject/SwinjectAutoregistration.git", from: "2.8.1"),
        .package(url: "https://github.com/Quick/Quick.git", from: "7.4.0"),
        .package(url: "https://github.com/Quick/Nimble.git", from: "13.2.0"),
        .package(url: "https://github.com/groue/CombineExpectations.git", from: "0.0.0"),
    ],
    targets: [
        .target(
            name: "FrameworkProviders",
            dependencies: [
                "FrameworkProviderProtocols",
                "FrameworkProviderFacades",
                "Swinject",
                "SwinjectAutoregistration"
            ]),
        .target(
            name: "FrameworkProviderFacades",
            dependencies: [
                "FrameworkProviderProtocols",
                "Swinject",
                "SwinjectAutoregistration"
            ]),
        .target(
            name: "FrameworkProviderTestFactories",
            dependencies: [
                "FrameworkProviderMocks",
                "FrameworkProviderFacades",
                "Swinject",
                "SwinjectAutoregistration"
            ]),
        .target(
            name: "FrameworkProviderProtocols",
            dependencies: ["DomainModels"]),
        .target(
            name: "FrameworkProviderMocks",
            dependencies: [
                "Utils",
                "FrameworkProviderProtocols"
            ]),
        .testTarget(
            name: "FrameworkProviderTests",
            dependencies: [
                "FrameworkProviders",
                "FrameworkProviderMocks",
                "Quick",
                "Nimble",
                "CombineExpectations"
            ])
    ]
)
