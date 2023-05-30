// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SwiftlaneCI",
	platforms: [.macOS(.v12)],
    dependencies: [
		.package(name: "Swiftlane", path: "../Swiftlane"),
    ],
    targets: [
        .executableTarget(
            name: "SwiftlaneCI",
            dependencies: [
				.byName(name: "Swiftlane"),
//				.byName(name: "SwiftlaneCore")
			]
		),
        .testTarget(
            name: "SwiftlaneCITests",
            dependencies: ["SwiftlaneCI"]
		),
    ]
)
