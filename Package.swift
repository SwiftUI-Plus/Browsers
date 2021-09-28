// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Browsers",
    platforms: [
        .iOS(.v13),
        .macOS(.v10_15)
    ],
    products: [
        .library(
            name: "Browsers",
            targets: ["Browsers"]
        ),
    ],
    dependencies: [
        .package(name: "Presentation", url: "https://github.com/SwiftUI-Plus/Presentation.git", .exactItem("1.1.0"))
    ],
    targets: [
        .target(
            name: "Browsers",
            dependencies: ["Presentation"]
        )
    ]
)
