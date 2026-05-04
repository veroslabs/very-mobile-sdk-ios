// swift-tools-version:5.7
import PackageDescription
let package = Package(
    name: "VerySDK",
    platforms: [.iOS(.v13)],
    products: [
        .library(name: "VerySDK", targets: ["VerySDKWrapper", "VerySDKBundledModel"]),
        .library(name: "VerySDKSlim", targets: ["VerySDKWrapper"]),
    ],
    targets: [
        .target(
  name: "VerySDKWrapper",
  dependencies: [
      "VerySDKBinary",
      "PalmAPISaas",
  ],
  path: "Sources"
        ),
        .target(
  name: "VerySDKBundledModel",
  path: "BundledModel",
  resources: [.process("packed_data.bin")]
        ),
        .binaryTarget(name: "VerySDKBinary", path: "VerySDK.xcframework"),
        .binaryTarget(name: "PalmAPISaas", path: "PalmAPISaas.xcframework"),
    ]
)
