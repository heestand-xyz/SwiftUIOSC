// swift-tools-version: 5.9

import PackageDescription

let package = Package(
    name: "SwiftUIOSC",
    platforms: [
        .iOS(.v17),
        .macOS(.v14),
    ],
    products: [
        .library(
            name: "SwiftUIOSC",
            targets: ["SwiftUIOSC"]
        ),
    ],
    dependencies: [
        .package(path: "../OSCTools2"),
    ],
    targets: [
        .target(
            name: "SwiftUIOSC",
            dependencies: [
                "OSCTools2",
            ]
        ),
    ]
)
