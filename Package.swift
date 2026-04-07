// swift-tools-version:5.7
import PackageDescription
let package = Package(
    name: "VeryMobileSDK",
    platforms: [.iOS(.v13)],
    products: [
        .library(name: "VeryMobileSDK", targets: ["VeryMobileSDK", "PalmAPISaas"]),
    ],
    targets: [
        .binaryTarget(name: "VeryMobileSDK", path: "VeryMobileSDK.xcframework"),
        .binaryTarget(name: "PalmAPISaas", path: "PalmAPISaas.xcframework"),
    ]
)
