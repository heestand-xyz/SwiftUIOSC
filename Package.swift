// swift-tools-version:5.3

import PackageDescription

let package = Package(
    name: "OSCWrapper",
    platforms: [
        .iOS(.v13),
        .tvOS(.v13),
        .macOS(.v10_15),
        .watchOS(.v6),
    ],
    products: [
        .library(name: "OSCWrapper", targets: ["OSCWrapper"]),
    ],
    dependencies: [
        .package(url: "https://github.com/SammySmallman/OSCKit", from: "2.1.0"),
    ],
    targets: [
        .target(name: "OSCWrapper", dependencies: ["OSCKit"]),
    ]
)
