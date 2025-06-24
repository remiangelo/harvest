// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "harvest",
    platforms: [
        .iOS(.v15),
        .macOS(.v10_15)
    ],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "harvest",
            targets: ["harvest"]),
    ],
    dependencies: [
        .package(url: "https://github.com/supabase/supabase-swift.git", from: "2.5.1")
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "harvest",
            dependencies: [
                .product(name: "Supabase", package: "supabase-swift")
            ]),
        .testTarget(
            name: "harvestTests",
            dependencies: ["harvest"]),
    ]
)
