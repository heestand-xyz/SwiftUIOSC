// swift-tools-version: 5.9

import PackageDescription

let package = Package(
    name: "SwiftUIOSC",
    platforms: [
        .iOS(.v17),
        .macOS(.v14),
    ],
    products: [
        .library(name: "SwiftUIOSC", targets: ["SwiftUIOSC"]),
    ],
    dependencies: [
        .package(url: "https://github.com/SammySmallman/OSCKit", from: "3.2.0"),
        .package(url: "https://github.com/ashleymills/Reachability.swift", from: "5.1.0"),
    ],
    targets: [
        .target(
            name: "SwiftUIOSC",
            dependencies: [
                "OSCKit",
                .product(name: "Reachability", package: "Reachability.swift")
            ]
        ),
    ]
)
