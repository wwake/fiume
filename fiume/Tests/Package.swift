// swift-tools-version: 5.10

import PackageDescription

let package = Package(
  name: "fiume swift-test package",

  platforms: [
    .macOS(.v10_15), .iOS(.v13), .watchOS(.v6), .tvOS(.v13), .macCatalyst(.v13), .visionOS(.v1)
  ],

  dependencies: [
    .package(url: "https://github.com/apple/swift-testing.git", branch: "main"),
  ],

  targets: [
    .testTarget(
      name: "fiumeTests",
      dependencies: [
        "fiume",
        .product(name: "Testing", package: "swift-testing"),
      ]
    ),
  ]
)
