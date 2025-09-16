// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "ViewModels",
    platforms: [
        .iOS(.v14), .macOS(.v11)
    ],
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "ViewModels",
            targets: ["ViewModels"]),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        // .package(url: /* package url */, from: "1.0.0"),
        .package(path: "../Logic"),
        .package(path: "../Interfaces"),
        .package(path: "../Repositories"),
        .package(path: "../DI"),
        .package(path: "../FrameworkProviders"),
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
            name: "ViewModels",
            dependencies: [
                "Swinject",
                "SwinjectAutoregistration",
                "Logic",
                "DI"
            ]),
        .testTarget(
            name: "ViewModelsTests",
            dependencies: ["ViewModels",
                           "Quick",
                           "Nimble",
                           "CombineExpectations",
                           .product(name: "FrameworkProviderMocks", package: "FrameworkProviders"),
                           .product(name: "FrameworkProviderTestFactories", package: "FrameworkProviders"),
                           .product(name: "UtilsTestExtensions", package: "Utils"),
                           .product(name: "InterfaceMocks", package: "Interfaces"),
                           .product(name: "RepositoriesMocks", package: "Repositories")]),
    ]
)
