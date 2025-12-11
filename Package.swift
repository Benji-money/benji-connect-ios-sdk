// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "BenjiConnect",
    platforms: [
        .iOS(.v12)
    ],
    products: [
        .library(
            name: "BenjiConnect",
            targets: ["BenjiConnect"]),
    ],
    dependencies: [],
    targets: [
        .target(
            name: "BenjiConnect",
            dependencies: []),
        .testTarget(
            name: "BenjiConnectTests",
            dependencies: ["BenjiConnect"]),
    ]
)
