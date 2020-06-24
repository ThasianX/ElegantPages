// swift-tools-version:5.2

import PackageDescription

let package = Package(
    name: "ElegantPages",
    platforms: [
        .iOS(.v13)
    ],
    products: [
        .library(
            name: "ElegantPages",
            targets: ["ElegantPages"]),
    ],
    dependencies: [],
    targets: [
        .target(
            name: "ElegantPages",
            dependencies: [])
    ]
)
