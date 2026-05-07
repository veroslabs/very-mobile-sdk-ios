// swift-tools-version:5.7
import PackageDescription

let package = Package(
    name: "VerySDK",
    platforms: [.iOS(.v13)],
    products: [
        // Default — bundled model
        .library(name: "VerySDK",     targets: ["VerySDKWrapper", "VerySDKBundledModel"]),
        // Slim — model downloads at first scan
        .library(name: "VerySDKSlim", targets: ["VerySDKWrapper"]),
    ],
    targets: [
        .target(
            name: "VerySDKWrapper",
            dependencies: ["VerySDKBinary", "PalmAPISaas"],
            path: "Sources/VerySDK"
        ),
        .target(
            name: "VerySDKBundledModel",
            path: "BundledModel",
            resources: [.process("packed_data.bin")]
        ),
        .binaryTarget(name: "VerySDKBinary", path: "VerySDK.xcframework"),
        .binaryTarget(name: "PalmAPISaas",   path: "PalmAPISaas.xcframework"),
    ]
)
