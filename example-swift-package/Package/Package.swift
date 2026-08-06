// swift-tools-version: 5.9

import PackageDescription

let package = Package(
    name: "ofxiOSBoostExample",
    platforms: [.iOS(.v12)],
    products: [
        .library(name: "ofxiOSBoostBridge", targets: ["ofxiOSBoostBridge"]),
        .executable(name: "BoostPackageExample", targets: ["BoostPackageExample"])
    ],
    targets: [
        .binaryTarget(name: "boost", path: "boost.xcframework"),
        .target(
            name: "ofxiOSBoostBridge",
            dependencies: ["boost"],
            path: "Sources/ofxiOSBoostBridge",
            publicHeadersPath: "include"
        ),
        .executableTarget(
            name: "BoostPackageExample",
            dependencies: ["ofxiOSBoostBridge"],
            path: "Sources/BoostPackageExample"
        )
    ],
    cxxLanguageStandard: .cxx11
)
