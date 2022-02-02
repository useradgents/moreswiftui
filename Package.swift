// swift-tools-version:5.3

import PackageDescription

let package = Package(
    name: "MoreSwiftUI",
    platforms: [.iOS(.v14), .macOS(.v11)],
    products: [
        .library(name: "MoreSwiftUI", targets: ["MoreSwiftUI"])
    ],
    dependencies: [
        .package(name: "Slab", url: "https://github.com/useradgents/slab.git", from: "1.3.0")
    ],
    targets: [
        .target(
            name: "MoreSwiftUI",
            dependencies: ["Slab"]
        ),
        .testTarget(name: "MoreSwiftUITests", dependencies: ["MoreSwiftUI"]
        )
    ]
)
