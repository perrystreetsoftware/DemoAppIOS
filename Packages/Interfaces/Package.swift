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
            name: "InterfacesMocks",
            targets: ["InterfacesMocks"]
        )
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        .package(path: "../DomainModels"),
        .package(url: "https://github.com/Swinject/Swinject.git", from: "2.8.0"),
        .package(url: "https://github.com/pointfreeco/combine-schedulers.git", from: "0.4.1"),
        .package(url: "https://github.com/birdrides/mockingbird.git", from: "0.20.0")
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "Interfaces",
            dependencies: ["Swinject", .product(name: "CombineSchedulers", package: "combine-schedulers")]),
        .target(
            name: "InterfacesMocks",
            dependencies: ["Interfaces", "DomainModels", .product(name: "Mockingbird", package: "mockingbird")]
        ),
        .testTarget(
            name: "InterfacesTests",
            dependencies: ["Interfaces", .product(name: "Mockingbird", package: "mockingbird"), "InterfacesMocks"]
        )
    ]
)
