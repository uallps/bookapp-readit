// swift-tools-version: 6.4
import PackageDescription

let package = Package(
    name: "ReadIt",
    products: [
        .library(
            name: "ReadIt",
            targets: ["ReadIt"]
        ),
    ],
    targets: [
        .target(
            name: "ReadIt",
            dependencies: [],
            path: "Sources/ReadIt"
        )
    ]
)