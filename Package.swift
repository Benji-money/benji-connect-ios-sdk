// swift-tools-version: 6.0
import PackageDescription

let package = Package(
    name: "BenjiConnect",
    platforms: [
        .iOS(.v15)
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
