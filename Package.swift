// swift-tools-version:5.3

import PackageDescription

let package = Package(
    name: "OSCWrapper",
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
