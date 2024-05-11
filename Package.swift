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
        .package(url: "https://github.com/heestand-xyz/OSCTools2", from: "2.0.0"),
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
