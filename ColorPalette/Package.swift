// swift-tools-version: 6.0
import PackageDescription

let package = Package(
    name: "ColorPalette",
    platforms: [
        .iOS(.v15), .macOS(.v12), .tvOS(.v15), .watchOS(.v8)
    ],
    products: [
        .library(name: "ColorPalette", targets: ["ColorPalette"]),
    ],
    targets: [
        .target(name: "ColorPalette"),
        .testTarget(name: "ColorPaletteTests", dependencies: ["ColorPalette"]),
    ]
)
