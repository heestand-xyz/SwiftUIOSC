// swift-tools-version:5.3

import PackageDescription

let package = Package(
    name: "SwiftUI-OSC",
    platforms: [
        .iOS(.v13),
        .tvOS(.v13),
        .macOS(.v10_15),
    ],
    products: [
        .library(name: "SwiftUI-OSC", targets: ["SwiftUI-OSC"]),
    ],
    dependencies: [
        .package(url: "https://github.com/SammySmallman/OSCKit", from: "2.1.0"),
        .package(name: "Reachability", url: "https://github.com/ashleymills/Reachability.swift", from: "5.1.0"),
    ],
    targets: [
        .target(name: "SwiftUI-OSC", dependencies: ["OSCKit", "Reachability"]),
    ]
)
