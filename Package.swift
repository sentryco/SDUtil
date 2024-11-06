// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "SDUtil",
    platforms: [
      .macOS(.v14), // macOS 14 and later
      .iOS(.v17) // iOS 17 and later
    ],
    products: [
        .library(
            name: "SDUtil",
            targets: ["SDUtil"])
    ],
    targets: [
        .target(
            name: "SDUtil"),
        .testTarget(
            name: "SDUtilTests",
            dependencies: ["SDUtil"])
    ]
)
