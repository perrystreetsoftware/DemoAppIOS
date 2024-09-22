// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Interfaces",
    platforms: [
        .iOS(.v14), .macOS(.v11)
    ],
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "Interfaces",
            targets: ["Interfaces"]
        ),
        .library(
            name: "InterfaceMocks",
            targets: ["InterfaceMocks"]
        )
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        .package(path: "../DomainModels"),
        .package(path: "../Utils"),
        .package(url: "https://github.com/Swinject/Swinject.git", from: "2.8.0"),
        .package(url: "https://github.com/pointfreeco/combine-schedulers.git", from: "0.4.1")
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "Interfaces",
            dependencies: [
                "Swinject",
                .product(name: "CombineSchedulers", package: "combine-schedulers"),
                "Utils"
            ]),
        .target(
            name: "InterfaceMocks",
            dependencies: ["Interfaces", "DomainModels"]
        ),
        .testTarget(
            name: "InterfacesTests",
            dependencies: ["Interfaces", "InterfaceMocks"]
        )
    ]
)
