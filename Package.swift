// swift-tools-version: 5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.
import PackageDescription

let package = Package(
    name: "Crayon",
    platforms: [
        .iOS(.v11),
        .tvOS(.v10),
        .watchOS(.v2),
        .macOS(.v10_10)
    ],
    products: [
        .library(
            name: "Crayon",
            targets: ["Crayon"]
        ),
    ],
    dependencies: [],
    targets: [
        .target(
            name: "Crayon",
            dependencies: []
        ),
        .testTarget(
            name: "CrayonTests",
            dependencies: ["Crayon"]
        )
    ]
)
