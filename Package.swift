// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "OMRuler",
    platforms: [
        .iOS(.v12)
    ],
    products: [
        .library(
            name: "OMRuler",
            targets: ["OMRuler"]),
    ],
    dependencies: [],
    targets: [
        .target(
            name: "OMRuler",
            dependencies: [])
    ]
)
