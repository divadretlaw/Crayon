// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.
import PackageDescription

let package = Package(
    name: "Crayon",
    platforms: [
        .iOS(.v12),
        .tvOS(.v12),
        .watchOS(.v4),
        .macOS(.v10_13),
        .visionOS(.v1)
    ],
    products: [
        .library(
            name: "Crayon",
            targets: ["Crayon"]
        ),
    ],
    targets: [
        .target(
            name: "Crayon"
        ),
        .testTarget(
            name: "CrayonTests",
            dependencies: ["Crayon"]
        )
    ]
)
