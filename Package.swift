// swift-tools-version:5.1
// The swift-tools-version declares the minimum version of Swift required to build this package.
import PackageDescription

let package = Package(
    name: "LCNibBridge",
    products: [
        .library(
            name: "LCNibBridge",
            targets: ["LCNibBridge"]),
    ],
    targets: [
        .target(name: "LCNibBridge")
    ],
    swiftLanguageVersions: [.v5]
)
