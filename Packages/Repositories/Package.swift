// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Repositories",
    platforms: [
        .iOS(.v14), .macOS(.v11)
    ],
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "Repositories",
            targets: ["Repositories"]
        ),
        .library(
            name: "RepositoriesMocks",
            targets: ["RepositoriesMocks"]
        )
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        .package(path: "../Interfaces"),
        .package(path: "../DomainModels"),
        .package(path: "../FrameworkProviders"),
        .package(path: "../DI"),
        .package(path: "../Utils"),
        .package(url: "https://github.com/Swinject/Swinject.git", from: "2.8.0"),
        .package(url: "https://github.com/Quick/Quick.git", from: "7.4.0"),
        .package(url: "https://github.com/Quick/Nimble.git", from: "13.2.0"),
        .package(url: "https://github.com/groue/CombineExpectations.git", from: "0.0.0"),
        .package(url: "https://github.com/Swinject/SwinjectAutoregistration.git", from: "2.8.1")
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "Repositories",
            dependencies: [
                "Interfaces",
                .product(name: "FrameworkProviderFacades", package: "FrameworkProviders"),
                "DomainModels",
                "Swinject",
                "SwinjectAutoregistration",
                "DI"
            ]
        ),
        .target(
            name: "RepositoriesMocks",
            dependencies: ["Repositories", "Interfaces"]
        ),
        .testTarget(
            name: "RepositoriesTests",
            dependencies: [
                "Repositories",
                "RepositoriesMocks",
                "Quick",
                "Nimble",
                "CombineExpectations",
                .product(name: "FrameworkProviderMocks", package: "FrameworkProviders"),
                .product(name: "FrameworkProviderTestFactories", package: "FrameworkProviders"),
                .product(name: "InterfaceMocks", package: "Interfaces"),
                .product(name: "InterfaceTestFactories", package: "Interfaces"),
                .product(name: "UtilsTestExtensions", package: "Utils")
            ]),
    ]
)
