// swift-tools-version: 6.0
import PackageDescription

let package = Package(
    name: "benji-connect-ios-sdk",
    platforms: [
        .iOS(.v14)
    ],
    products: [
        .library(
            name: "BenjiConnect",
            targets: ["BenjiConnect"]
        )
    ],
    targets: [
        .target(
            name: "BenjiConnect"
        )
    ]
)
