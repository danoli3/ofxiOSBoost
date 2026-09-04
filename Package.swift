// swift-tools-version: 5.9

import PackageDescription

let package = Package(
    name: "Boost",
    platforms: [
        .iOS(.v12)
    ],
    products: [
        .library(name: "ofxiOSBoost", targets: ["ofxiOSBoost"]),
        .library(name: "boost", targets: ["boost"])
    ],
    targets: [
        .binaryTarget(
            name: "boost",
            url: "https://github.com/danoli3/ofxiOSBoost/releases/download/1.88.0/ofxiOSBoost-1.88.0-xcframework.zip",
            checksum: "8df8b1acfdbfa2d7926e7beb9af3b4038519bd9ef33847862628ffd1ce90a367"
        ),
        .target(
            name: "ofxiOSBoost",
            dependencies: ["boost"],
            path: "example-swift-package/Package/Sources/ofxiOSBoostBridge",
            publicHeadersPath: "include"
        )
    ],
    cxxLanguageStandard: .cxx20
)
