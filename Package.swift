// swift-tools-version:5.3

import PackageDescription

let package = Package(
    name: "MoreSwiftUI",
    platforms: [.iOS(.v14)],
    products: [
        .library(name: "MoreSwiftUI", targets: ["MoreSwiftUI"])
    ],
    dependencies: [
        .package(name: "Slab", url: "https://bitbucket.org/useradgents/slab.git", from: "1.0.0")
    ],
    targets: [
        .target(
            name: "MoreSwiftUI",
            dependencies: [
                .product(name: "Slab", package: "Slab")
            ]
        ),
        .testTarget(name: "MoreSwiftUITests", dependencies: ["MoreSwiftUI"]
        )
    ]
)
